# coding: utf-8
#
# app/myapp.rb
#
# Time-stamp: <2016-02-28 09:35:44 (ryosuke)>
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src/')

require('sinatra/base')
require('haml')
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

  #------------------
  before do
    @calc_list = Calculators.map{|x| x[:name]}
  end
  #------------------

  #--- ROOT ---------
  get('/') do
    haml :index #erb :index
    #haml '%h1= msg', :locals => {:msg => 'Under Constraction' }
  end
  #------------------

#  #--- FoxCalc ------
#  get('/FoxCalc/?:word?/?:gen?'){ haml :foxcalc } #erb :foxcalc }
#  post('/FoxCalc'){ haml :foxcalc } #erb :foxcalc }
#  #------------------

  #--- Standard -----
  get('/Standard/?:word?/?:gen?') do
    @myword = params[:word]
    @mygen = params[:gen]
    haml :standard
  end
  post('/Standard') do
    w = params[:word]
    g = ''
    if (params.has_key?("gen")) then
      g = '/' + params[:gen] unless params[:gen].empty?
    end
    redirect '/Standard/' + w + g
    #haml "%p= 'params[:gen]= ' + params[:gen].inspect"
  end
  #------------------

  #--- Symplectic ---------
  get('/Symplectic') do
    haml :symplectic
  end

  ### log2
  get('/Symplectic/log2/?:word?') do
    @alert = (params[:word] == 'alert')
    @items = Item.all(:order => :created.desc)
    haml :symplectic_log2
  end
  get('/Symplectic/log2/delete/:id') do
    item = Item.first(:id => params[:id])
    item.destroy
    redirect '/Symplectic/log2'
  end

  post('/Symplectic/log2') do
    if /[^aAbBsStTxXyY]/ =~ params[:word]
      alert = '/alert'
    else
      alert = ''
      mylb = calc_symp_log2(params[:word]).map{|lb| lb.to_s }.join('+').gsub('+-','-')
      Item.create(:word => params[:word], :result => mylb, :created => Time.now)
    end
    redirect '/Symplectic/log2' + alert
  end

  ### ellab
  get('/Symplectic/ellab/?:wa?/?:wb?') do
    haml :symplectic_ellab
  end
  post('/Symplectic/ellab') do
    redirect '/Symplectic/ellab/' + params[:wa] + '/' + params[:wb]
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
    # def calc_symp_log2_join(w)
    #   lb_arr = calc_symp_log2(w)
    #   lb_arr.empty? ? "0" : lb_arr.map{|lb| lb.to_s }.join('+').gsub('+-','-')
    # end
    def calc_ellab(wa,wb)
      unless (wa.nil? || wa.empty? || wb.nil? || wb.empty?) then
        lb_arr = calc_symp_log2(wa)
        lb_str = lb_arr.map{|lb| lb.to_s }.join('+').gsub('+-','-')
        #---
        #vec_arr = Word.new(wb).each_gen
        #vec_str = vec_arr.each do |g|
        #( (g.inverse? ? '-' : '') + g.letter ).sub(/\w+/, '|\&|')
        #end
        #---
        lhe = 'l()'.insert(2, wa) + '||'.insert(1, wb)
        mhe = 'l()'
        #mhe = lb_str.sub(/.+/, '(\&)') + vec_str..sub(/.+/, '(\&)')
        #rhe = vec_arr.each do |v|
        #
        #end
      end
      return [lhe, mhe].join(' = ')
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
#------------------------------------------------------

#---------------------------
# End of File
#---------------------------
