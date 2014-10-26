#
# app/myapp.rb
#
# Time-stamp: <2014-10-26 17:02:01 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src/')
require('sinatra/base')
require('haml')

require('FoxCalc')
require('StdMagnusExp')
require('GrouplikeExp')

#---------------------------
class MyApp < Sinatra::Base

  Calculators = [ {name: "FoxCalc", path: "/FoxCalc", title: "Fox Calculas"},
                  {name: "Standard", path: "/Standard", title: "Standard Magnus Expansion"},
                  {name: "Grouplike", path: "/Grouplike", title: "Group-like Expansion"},
                  {name: "Symplectic", path: "/Symplectic", title: "Symplectic Expansion"}]

  
  #--- GET ---------
  get('/'){ erb :index }
  get('/more/*'){ params[:splat] }
  get('/haml/:name'){ haml :hamltest }
  #get('/form'){ erb :form }
  #---
  get('/FoxCalc/?:word?/?:gen?'){ erb :foxcalc }
  get('/Standard/?:word?'){ erb :standard }
  get('/Grouplike/?:word?'){ erb :grouplike }
  #-----------------

  #--- POST --------
  post('/Standard'){ erb :standard }
  post('/FoxCalc'){ erb :foxcalc }
  post('/Grouplike'){ erb :grouplike }
  #-----------------

  #--- NOT FOUND ---
  not_found{ halt 404, '404: page not found' }
  #-----------------
  
  #--- Helpers -----
  def active_page?(path='')
    request.path_info == '/' + path
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
      theta = GrouplikeExp.instance
      lb_arr_smp = theta.log2_simplify(Word.new(w))
      result = if lb_arr_smp.empty? then
                 "0"
               else
                 lb_arr_smp.map{|lb| lb.to_s }.join('+').gsub('+-','-')
               end
      "#{w}  -->  #{result}"
    end
  end
  #-----------------

end
#---------------------------

#---------------------------
# End of File
#---------------------------
