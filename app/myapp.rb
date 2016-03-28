# coding: utf-8
#
# app/myapp.rb
#
# Time-stamp: <2016-03-29 00:06:53 (ryosuke)>
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src/')

require('sinatra/base')
require('slim')
require('data_mapper')
#require('date')
require('pry')

require('FoxCalc')
require('StdMagnusExp')
require('SymplecticExp')

#------------------------------------------------------
class MyApp < Sinatra::Base

  Calculators = [ #{name: "FoxCalc", path: "/FoxCalc", title: "Fox Calculas"},
                  {name: "Standard", path: "/Standard", title: "Standard Magnus Expansion"},
                  {name: "Symplectic", path: "/Symplectic", title: "Symplectic Expansion"}]

  SymplecticBasis = [%w[A B], %w[S T], %w[X Y]]

  #---[ Filter ]------------------------------------
  before do
    @calc_list = Calculators.map{|x| x[:name]}
  end
  #-------------------------------------------------

  #---[ Routing ]-----------------------------------
  ### ROOT ###
  get('/') do
    slim :index
    #slim 'h1= msg', locals: { msg: 'Under Constraction' }
  end

  ##################
  ### Standard
  get('/Standard/?:word?/?:gen?') do
    #@myword, @mygen = params[:word], params[:gen]
    @output_st = calc_std params[:word] #@myword
    @output_fx = calc_fc params[:word], params[:gen]
    slim :standard
  end
  post('/Standard') do
    w, g = params[:word], ''
    if (params.has_key?("gen")) then
      g = '/' + params[:gen] unless params[:gen].empty?
    end
    redirect '/Standard/' + w + g
    #slim "p= 'params[:gen]= ' + params[:gen].inspect"
  end

  ##################
  ### Symplectic
  #--- TOP
  get('/Symplectic') do
    slim :symplectic
  end

  #--- log2
  get('/Symplectic/log2/?:word?') do
    @alert = (params[:word] == 'alert')
    @empty = false
    #---
    unless (@alert || params[:word].nil?)
      mylb = calc_symp_log2(params[:word]).map{|lb| lb.to_s }.join('+').gsub('+-','-')
      item = Item.create(:word => params[:word], :result => mylb, :created => Time.now)
      @empty = !(item.saved?)
    end
    @items = Item.all(:order => :created.desc)
    #---
    slim :symplectic_log2
  end
  get('/Symplectic/log2/delete/:id') do
    (Item.first(:id => params[:id])).destroy
    redirect '/Symplectic/log2'
  end

  post('/Symplectic/log2') do
    str = symplectic_check(params[:word]) ? params[:word] : 'alert'
    redirect '/Symplectic/log2/' + str
  end

  #--- ellab
  get('/Symplectic/ellab/?:wa?/?:wb?') do
    unless ( params[:wa].nil? || params[:wb].nil? ) then
      @output1, @output2 = '', ''
      unless (params[:wa] == 'alert')
        lab_str = 'ell' + "(#{params[:wa]})" + "|#{params[:wb]}|"
        lba_str = 'ell' + "(#{params[:wb]})" + "|#{params[:wa]}|"
        lab = calc_ellab(params[:wa], params[:wb])
        lba = calc_ellab(params[:wb], params[:wa])
        @output11 = lab_str + ' = ' + lab.join(' = ')
        @output12 = lba_str + ' = ' + lba.join(' = ')
        @output2 = lab_str + '+' + lba_str + ' = ' + (lab[-1] + lba[-1]).simplify.to_s
      end
    end
    slim :symplectic_ellab
  end

  post('/Symplectic/ellab') do
    str = if ( params[:wa].empty? || params[:wb].empty? ) then
            ''
          elsif symplectic_check(params[:wa]+params[:wb]) then
            '/' + params[:wa] + '/' + params[:wb]
          else
            '/alert'
          end
    redirect '/Symplectic/ellab' + str
  end

  ##################
  ### OTHERS
  get('/more/*'){ params[:splat] }

  ##################
  ### NOT FOUND
  not_found{ halt 404, '404: page not found' }
  #-------------------------------------------------

  #---[ Helpers ]-----------------------------------
  helpers do
    def active_page?(path='')
      request.path_info.include?(path)
    end
    def symplectic_check(w)
      w.delete!('()')
      letters = SymplecticBasis.flatten.join
      re = Regexp.new( "[^#{letters.downcase + letters.upcase}]" )
      (re =~ w).nil?
    end
    #--- calculators ---
    def calc_fc(w, g)
      unless (w.nil? || w.empty?) then
        gg = (g.nil?) ? Generator.new('a') : Generator.new(g)
        ww = (w.nil?) ? Word.new('a') : Word.new(w)
        "#{w}  --(d/d#{g})-->  #{FoxCalculator[gg].send(ww).to_s}"
      end
    end
    #---
    def calc_std(w)
      unless (w.nil? || w.empty?) then
        theta = StdMagnusExp.instance
        "#{w}  -->  #{theta.expand(Word.new(w)).to_s}"
      end
    end
    #---
    def calc_symp_log2(w)
      unless (w.nil? || w.empty?) then
        theta = SymplecticExp.instance
        theta.log2_simplify(Word.new(w))
      else
        [LieBracket.new("0")]
      end
    end
    #---
    def calc_ellab(wa,wb)
      raise ArgumentError, 'You need to give two words' if ( (wa.nil? || wa.empty?) || (wb.nil? || wb.empty?) )
      #---
      lb_arr = calc_symp_log2(wa)
      #--- abelianization of the word wb ---
      wb_abel = FormalSum.new()
      Word.new(wb).each_gen do |g|
        coeff = (g.inverse?) ? -1 : 1
        term = Term.new(g.letter.upcase, coeff)
        wb_abel = wb_abel + FormalSum.new(term)
      end
      #---
      lb_str = lb_arr.map{|lb| (lb*2).to_s.upcase }.join('+').gsub('+-','-').sub(/.+/, '(\&)')
      eq1 = '1/2' + lb_str + "(#{wb_abel.simplify.to_s})"
      #---
      eq2 = FormalSum.new()
      lb_arr.each do |lb|
        #--- action of lb on v
        wb_abel.terms.each do |trm|
          lb_act = [lb.couple, lb.couple.reverse].map do |cpl|
            int_num = intersection_form(trm[:word], cpl[0].to_s) * trm[:coeff]
            FormalSum.new(cpl[1]) * int_num * lb.coeff
          end
          eq2 = eq2 + ( lb_act[0] - lb_act[1] )
        end
        #---
      end
      return [eq1, eq2.simplify]
    end
    #---
    def intersection_form(s1, s2)
      raise ArgumentError, 'At least one of the argument is not a string' unless ( s1.is_a?(String) && s2.is_a?(String) )
      s_pair = [s1, s2]
      if SymplecticBasis.include?(s_pair) then
        1
      elsif SymplecticBasis.include?(s_pair.reverse) then
        -1
      else
        0
      end
    end
  end
  #-------------------------------------------------

  #---[ DataMapper ]--------------------------------
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app/public/symplectic_history.db")
  class Item
    include DataMapper::Resource
    property :id, Serial
    property :word, Text, :required => true
    property :result, Text, :required => true
    #property :done, Boolean, :required => true, :default => false
    property :created, DateTime
  end
  DataMapper.finalize.auto_upgrade!
  #-------------------------------------------------

end
#------------------------------------------------------

#---------------------------
# End of File
#---------------------------
