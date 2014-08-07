# coding: utf-8
#
# spec_helper.rb
# 
# Time-stamp: <2014-08-07 11:58:20 (ryosuke)>

$LOAD_PATH.push File.expand_path(File.dirname(__FILE__) + '/../src')

require('rspec')
require('pry')
require('pry-byebug')

RSpec.configure do |config|
  # focus: true が設定された example がある時それの example だけを実行する
  config.filter_run :focus
  # focus: true が設定された example がない時全ての example を実行する
  config.run_all_when_everything_filtered = true
  
  # エラーが出たら即停止
  config.fail_fast = true
  
  # テストをランダムな順序で実行する
  #config.order = :random
  
  # expect 記法を強制する
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end

#-----------------------------
#--- End of File -------------
#-----------------------------
