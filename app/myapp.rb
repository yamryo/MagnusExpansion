# coding: utf-8
#
# app/myapp.rb
#
# Time-stamp: <2015-03-04 12:30:48 (kaigishitsu)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src/')

require('sinatra/base')
require('haml')
require('data_mapper')
#require('sinatra/reloader')
#require('date')

require('FoxCalc')
require('StdMagnusExp')
require('SymplecticExp')

#---------------------------
class MyApp < Sinatra::Base

  Calculators = [ {name: "FoxCalc", path: "/FoxCalc", title: "Fox Calculas"},
                  {name: "Standard", path: "/Standard", title: "Standard Magnus Expansion"},
                  {name: "Symplectic", path: "/Symplectic", title: "Symplectic Expansion"}]

  #--- ROOT ---------
  get('/'){ erb :index }
  #------------------
  
  #--- FoxCalc ------
  get('/FoxCalc/?:word?/?:gen?'){ erb :foxcalc }
  post('/FoxCalc'){ erb :foxcalc }
  #------------------
  
  #--- Standard -----
  #get('/Standard/?:word?'){ erb :standard }
  #post('/Standard'){ erb :standard }
  get('/Standard/?:word?') do
    @myword = params[:word]
    erb :standard
  end
  post('/Standard'){ redirect '/Standard/' + params[:word] }
  #------------------
  
  #--- Symplectic ---
  get('/Symplectic/?:word?') do
    @alert = (params[:word] == 'alert')
    @items = Item.all(:order => :created.desc)
    erb :symplectic
  end
  get('/Symplectic/delete/:id') do
    item = Item.first(:id => params[:id])
    item.destroy
    redirect '/Symplectic'
  end
  #---
  post('/Symplectic') do
    if /[^aAbBsStTxXyY]/ =~ params[:word]
      alert = '/alert'
    else
      alert = ''
      mylb = calc_log2_simplify(params[:word]) 
      Item.create(:word => params[:word], :result => mylb, :created => Time.now)
    end
    redirect '/Symplectic' + alert
  end
  #-----------------

  #--- OTHERS ---------
  get('/more/*'){ params[:splat] }
  get('/haml/:name'){ haml :hamltest }
  #------------------
  
  #--- NOT FOUND ---
  not_found{ halt 404, '404: page not found' }
  #-----------------
  
  #--- Helpers -----
  helpers do
    def active_page?(path='')
      request.path_info.include?(path)
    end
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
    def calc_log2_simplify(w)
      unless (w.nil? || w.empty?) then
        theta = SymplecticExp.instance
        lb_arr_smp = theta.log2_simplify(Word.new(w))
        result = if lb_arr_smp.empty? then
                   "0"
                 else
                   lb_arr_smp.map{|lb| lb.to_s }.join('+').gsub('+-','-')
                 end
        #"#{w}  -->  #{result}"
      end
    end
  end
  #-----------------

  #--- DataMapper -------------------
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
  #---------------------------

end
#---------------------------
#---------------------------
# End of File
#---------------------------
