# coding: utf-8
#
# app/myapp.rb
#
# Time-stamp: <2016-03-25 14:56:04 (ryosuke)>
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src/')

require('sinatra/base')
require('slim')
require('data_mapper')
#require('date')

require('FoxCalc')
require('StdMagnusExp')
require('SymplecticExp')

#------------------------------------------------------
class MyApp < Sinatra::Base

  Calculators = [ #{name: "FoxCalc", path: "/FoxCalc", title: "Fox Calculas"},
                  {name: "Standard", path: "/Standard", title: "Standard Magnus Expansion"},
                  {name: "Symplectic", path: "/Symplectic", title: "Symplectic Expansion"}]

  SymplecticGens = [%w[a b], %w[s t], %w[x y]]

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
      lhe = 'ell' + '()'.insert(1, params[:wa]) + '||'.insert(1, params[:wb])
      @output = lhe + ' = ' + ((params[:wa] == 'alert') ? 'alert' : calc_ellab(params[:wa], params[:wb]))
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
      sympgens = SymplecticGens.flatten.join
      re = Regexp.new( "[^#{sympgens + sympgens.upcase}]" )
      (re =~ w).nil?
    end
    #--- calculators
    def calc_fc(w, g)
      unless (w.nil? || w.empty?) then
        gg = (g.nil?) ? Generator.new('a') : Generator.new(g)
        ww = (w.nil?) ? Word.new('a') : Word.new(w)
        "#{w}  --(d/d#{g})-->  #{FoxCalculator[gg].send(ww).to_s}"
      end
    end
    def calc_std(w)
      unless (w.nil? || w.empty?) then
        theta = StdMagnusExp.instance
        "#{w}  -->  #{theta.expand(Word.new(w)).to_s}"
      end
    end
    def calc_symp_log2(w)
      unless (w.nil? || w.empty?) then
        theta = SymplecticExp.instance
        theta.log2_simplify(Word.new(w))
      else
        [LieBracket.new("0")]
      end
    end
    def calc_ellab(wa,wb)
      eq1, eq2, eq3, eq4 = 'emp', 'ty', '!', '?'
      unless ( (wa.nil? || wa.empty?) || (wb.nil? || wb.empty?) ) then
        #---
        lb_arr = calc_symp_log2(wa)
        vec_arr = []
        Word.new(wb).each_gen{ |g| vec_arr << g }
        pair_arr = lb_arr.each_with_object([]) do |lb, couples|
          couples << vec_arr.map{ |v| [lb, v]}
        end
        #---
        lb_str_arr = lb_arr.map{|lb| lb.to_s }
        vec_str_arr = vec_arr.map{ |g| ((g.inverse? ? '-' : '') + g.letter).sub(/\w+/, '|\&|') }
        pair_str_arr = lb_str_arr.each_with_object([]) do |lbs, pairs|
          pairs << vec_str_arr.map{ |vs| lbs + vs.sub(/.+/, '(\&)') }
        end
        #---
        #---
        eq1 = ([lb_str_arr, vec_str_arr].map{ |sa| sa.join('+').gsub('+-','-').sub(/.+/, '(\&)') }).join
        eq2 = pair_str_arr.flatten.join('+').gsub('+-','-')
        eq3 = pair_arr.flatten(1).map do |c|
          lb_f, lb_l = c[0].couple[0], c[0].couple[1]
          v = ((c[1].inverse? ? '-' : '') + c[1].letter).sub(/\w+/, '|\&|')
          ft = "(#{v}.|#{lb_f.to_s}|)|#{lb_l.to_s}|"
          lt = "(#{v}.|#{lb_l.to_s}|)|#{lb_f.to_s}|"
          "#{c[0].coeff}"+[ft, lt].join('-').gsub('--','+').sub(/.+/, '(\&)')
        end.join('+').gsub('+-','-')
        # eq4 = pair_arr.flatten(1).map do |c|
        #   lb_f, lb_l = c[0].couple[0], c[0].couple[1]
        #   case [c[1].letter, lb_f.to_s]
        #   when
        #   ft = "(#{v}.|#{lb_f.to_s}|)|#{lb_l.to_s}|"
        #   lt = "(#{v}.|#{lb_l.to_s}|)|#{lb_f.to_s}|"
        #   "#{c[0].coeff}"+[ft, lt].join('-').gsub('--','+').sub(/.+/, '(\&)')
        # end.join('+').gsub('+-','-')
        #---
      end
      return [eq1, eq3, eq4].join(' = ')
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
