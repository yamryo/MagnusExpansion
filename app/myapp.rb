# coding: utf-8
#
# app/myapp.rb
#
# Time-stamp: <2016-03-18 17:40:16 (ryosuke)>
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src/')

require('sinatra/base')
require('slim')
require('data_mapper')
#require('sinatra/reloader')
#require('date')

require('FoxCalc')
require('StdMagnusExp')
require('SymplecticExp')

#------------------------------------------------------
class MyApp < Sinatra::Base

  Calculators = [ #{name: "FoxCalc", path: "/FoxCalc", title: "Fox Calculas"},
                  {name: "Standard", path: "/Standard", title: "Standard Magnus Expansion"},
                  {name: "Symplectic", path: "/Symplectic", title: "Symplectic Expansion"}]

  #set :haml, :escape_html => true

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
    #@myword = params[:word]
    #@mygen = params[:gen]
    @output_st = calc_std params[:word] #@myword
    @output_fx = calc_fc params[:word], params[:gen]
    slim :standard
  end
  post('/Standard') do
    w = params[:word]
    g = ''
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
    @empty = (params[:word] == 'empty')
    @items = Item.all(:order => :created.desc)
    slim :symplectic_log2
  end
  get('/Symplectic/log2/delete/:id') do
    item = Item.first(:id => params[:id])
    item.destroy
    redirect '/Symplectic/log2'
  end

  post('/Symplectic/log2') do
    if /[^aAbBsStTxXyY]/ =~ params[:word]
      str = '/alert'
    else
      mylb = calc_symp_log2(params[:word]).map{|lb| lb.to_s }.join('+').gsub('+-','-')
      item = Item.create(:word => params[:word], :result => mylb, :created => Time.now)
      str = (item.saved?) ? '' : '/empty'
    end
    redirect '/Symplectic/log2' + str
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
          else
            if /[^aAbBsStTxXyY]/ =~ params[:wa]+params[:wb] then
              '/alert'
            else
              '/' + params[:wa] + '/' + params[:wb]
            end
          end
    redirect '/Symplectic/ellab' + str
  end

#  ##################
#  ### FoxCalc
#  get('/FoxCalc/?:word?/?:gen?'){ haml :foxcalc } #erb :foxcalc }
#  post('/FoxCalc'){ haml :foxcalc } #erb :foxcalc }

  ##################
  ### OTHERS
  get('/more/*'){ params[:splat] }
  #get('/haml/:name'){ haml :hamltest }

  ##################
  ### NOT FOUND
  not_found{ halt 404, '404: page not found' }
  #-------------------------------------------------

  #---[ Helpers ]-----------------------------------
  helpers do
    def active_page?(path='')
      request.path_info.include?(path)
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
      eq1, eq2 = 'emp', 'ty'
      unless ( (wa.nil? || wa.empty?) || (wb.nil? || wb.empty?) ) then
        lb_arr = calc_symp_log2(wa)
        lb_str = lb_arr.map{|lb| lb.to_s }.join('+').gsub('+-','-')
        #---
        vec_arr = []
        Word.new(wb).each_gen{ |g| vec_arr << g }
        vec_str = vec_arr.map{ |g| ((g.inverse? ? '-' : '') + g.letter).sub(/\w+/, '|\&|') }.join('+').gsub('+-','-')
        #---
        eq1 = '()'.insert(1, lb_str) + vec_str.sub(/.+/, '(\&)')
        # tmp_arr = []
        # lb_arr.each do |lb|
        #   tmp_arr << vec_arr.map do |v|
        #     lb.to_s + v.to_char
        #   end
        # end
        tmp_arr = lb_arr.each_with_object([]) do |lb, a|
          a << vec_arr.map do |v|
            lb.to_s + v.to_char
          end
        end
        eq2 = tmp_arr.flatten!.join('+').gsub('+-','-')
      end
      return [eq1, eq2].join(' = ')
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
