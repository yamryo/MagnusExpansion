source 'https://rubygems.org'

group :development do
  gem 'pry'
#  gem 'pry-nav'
  
  if RUBY_VERSION >= '2.0.0'
    gem 'pry-byebug'
  else
  # 以下はRuby1.9の時のみ使う(pry-byebugの代わりに)
  # debuggerは1.9以下でしか動作しない, remote は byebug で使えないようになった
    gem 'pry-debugger'
    gem 'pry-remote'
  end
  
  platform :ruby_19 do
    gem 'coolline'
  end
end

group :test do
  gem 'rspec'
  gem 'guard-rspec'
#  gem 'rb-readline'
end
