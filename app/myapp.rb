#
# app/myapp.rb
#
# Time-stamp: <2014-10-26 00:10:16 (ryosuke)>
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
  def calc_log2(w)
    unless (w.nil? || w.empty?) then
      theta = GrouplikeExp.instance
      lb_arr = theta.log2(Word.new(w))
      #result = lb_arr.map{|lb| lb.to_s }.join('+').gsub('+-','-')
      lb_arr_smp = []
      while (not lb_arr.empty?) do
        lb_arr_smp << lb_arr.shift
        k = lb_arr.index do |lb|
              lb.inspect_couple == lb_arr_smp.last.inspect_couple
            end
            unless k.nil? then
              lb_arr[k].coeff = lb_arr[k].coeff + lb_arr_smp.last.coeff
              lb_arr_smp.pop
            end
            lb_arr.delete_if{ |lb| lb.coeff == 0 }
      end
      result = lb_arr_smp.map{|lb| lb.to_s }.join('+').gsub('+-','-')
      result = "0" if result.empty?
      "#{w}  -->  #{result}"
    end
  end
  #-----------------

end
#---------------------------

#---------------------------
# End of File
#---------------------------
