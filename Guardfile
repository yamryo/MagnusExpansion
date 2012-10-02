# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :spec_paths => "test" do
  watch(%r{^test/.+_spec\.rb$})
  watch(%r{^src/(.+)\.rb$})     { |m| "test/#{m[1]}_spec.rb" }
end
