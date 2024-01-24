require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "sendgrid_toolkit"
  gem.homepage = "http://github.com/freerobby/sendgrid_toolkit"
  gem.license = "MIT"
  gem.summary = "sendgrid_toolkit = Sendgrid + Ruby"
  gem.description = "A Ruby wrapper and utility library for communicating with the Sendgrid API."
  gem.authors = ["promoboxx people"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'
task :default => :spec
RSpec::Core::RakeTask.new
