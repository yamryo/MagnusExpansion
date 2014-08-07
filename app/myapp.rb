#
# app/myapp.rb
#
# Time-stamp: <2014-08-07 17:36:47 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src/')
require('sinatra/base')

require('FoxCalc')
require('StdMagnusExp')

#---------------------------
class MyApp < Sinatra::Base
  #--- GET ---------
  get('/'){ erb :index }
  get('/more/*'){ params[:splat] }
  get('/form'){ erb :form }
  #---
  get('/FoxCalc/:word/:gen'){ erb :foxcalc }
  get('/Standard/:word'){ erb :standard }
  #-----------------

  #--- POST --------
  post('/form') do
    params['word'] = params[:message]
    erb :standard
  end
  #-----------------

  #--- NOT FOUND ---
  not_found{ halt 404, '404: page not found' }
  #-----------------
end
#---------------------------

#---------------------------
# End of File
#---------------------------
