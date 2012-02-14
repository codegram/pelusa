# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pelusa/version"

Gem::Specification.new do |s|
  s.name        = "pelusa"
  s.version     = Pelusa::VERSION
  s.authors     = ["Josep M. Bach"]
  s.email       = ["josep.m.bach@gmail.com"]
  s.homepage    = "http://github.com/codegram/pelusa"
  s.summary     = %q{Static analysis Lint-type tool to enforce OO best practices in your Ruby code}
  s.description = %q{Static analysis Lint-type tool to enforce OO best practices in your Ruby code}

  s.rubyforge_project = "pelusa"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = Dir["test/**/*.rb"]
  s.executables   = ["bin/pelusa"]
  s.require_paths = ["lib"]

  s.add_development_dependency 'mocha'
end
