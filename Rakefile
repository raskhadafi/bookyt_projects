# encoding: utf-8

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
  gem.name = "bookyt_projects"
  gem.homepage = "http://github.com/raskhadafi/bookyt_projects"
  gem.license = "MIT"
  gem.summary = %Q{Rails engine for project management}
  gem.description = %Q{Rails engine for project management it's used to extend the functionallity of bookyt.}
  gem.email = "roman.simecek@cyt.ch"
  gem.authors = ["Roman Simecek"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

