# A sample Guardfile
# More info at https://github.com/guard/guard#readme

group :web do
  guard 'livereload' do
    watch(%r{app/.+\.rb})
    watch(%r{app/views/.+\.(erb|haml|slim)$})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{public/.+\.(css|js|html)})
    watch(%r{config/locales/.+\.yml})
    # Rails Assets Pipeline
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
  end
end

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rsspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separetly)
#  * 'just' rspec: 'rspec'

group :spec do
  guard :rspec, cmd: 'bundle exec rspec' do
    watch(%r{^spec/.+_spec\.rb$})
      watch(%r{^src/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
        watch('spec/spec_helper.rb')  { "spec" }
  end
end

