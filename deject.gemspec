# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "deject/version"

Gem::Specification.new do |s|
  s.name        = "deject"
  s.version     = Deject::VERSION
  s.authors     = ["Josh Cheek"]
  s.email       = ["josh.cheek@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Simple dependency injection}
  s.description = %q{Provides a super simple API for dependency injection}

  s.rubyforge_project = "deject"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  # s.add_runtime_dependency "rest-client"
end