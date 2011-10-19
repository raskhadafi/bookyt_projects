# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../lib', __FILE__)
require 'bookyt_projects/version'

Gem::Specification.new do |s|
  # Description
  s.name = "bookyt_projects"
  s.version      = BookytPos::VERSION
  s.authors      = ["Roman Simecek (CyT)", "Simon Hürlimann (CyT)"]
  s.email        = ["roman.simecek@cyt.ch", "simon.huerlimann@cyt.ch"]
  s.homepage     = "https://github.com/raskhadafi/bookyt_projects"
  s.summary      = "Project management plugin for bookyt"
  s.description = "This plugin extends bookyt with project management functionallty."

  # Files
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files        = `git ls-files app lib config db`.split("\n")

  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.licenses = ["MIT"]

  # Dependencies
  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.1.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>)
    else
      s.add_dependency(%q<rails>, ["~> 3.1.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rspec-rails>)
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.1.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rspec-rails>)
  end
end
