#
# app/myapp.rb
#
# Time-stamp: <2014-08-08 15:36:07 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src/')
require('sinatra/base')

require('FoxCalc')
require('StdMagnusExp')
require('GrouplikeExp')

#---------------------------
class MyApp < Sinatra::Base

  #--- Helpers -----
  def active_page?(path='')
    request.path_info == '/' + path
  end
  #-----------------

  #--- GET ---------
  get('/'){ erb :index }
  get('/more/*'){ params[:splat] }
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
end
#---------------------------

#---------------------------
# End of File
#---------------------------
