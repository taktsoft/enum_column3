# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "enum_column3"
  s.version     = "0.1.3"
  s.authors     = ["Nick Pohodnya", "Michael Nowak"]
  s.email       = ["", "nowak@taktsoft.com"]
  s.homepage    = "http://github.com/taktsoft/enum_column"
  s.summary     = %q{Enable enum column-type for mysql2 connection-adapter}
  s.description = s.summary

  s.rubyforge_project = "enum_column3"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "rails", "~> 3.0"
end
