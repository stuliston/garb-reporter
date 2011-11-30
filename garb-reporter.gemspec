# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "garb-reporter/version"

Gem::Specification.new do |s|
  s.name        = "garb-reporter"
  s.version     = GarbReporter::VERSION
  s.authors     = ["Stuart Liston"]
  s.email       = ["stuart.liston@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Provides a reporter class for Garb}
  s.description = %q{GarbReporter removes the need in Garb to create a new class for every report by offering a querying api that dynamically creates the Garb classes for you in the background.}

  # Only running dependency is Garb (and its dependencies)
  s.add_dependency "garb", ">= 0.9.1"

  # Development dependencies:
  s.add_development_dependency "rspec", ">= 2.7.0"

  s.rubyforge_project = "garb-reporter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
