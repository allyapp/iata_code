# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iata_code/version'

Gem::Specification.new do |spec|
  spec.name          = "iata_code"
  spec.version       = IATACode::VERSION
  spec.authors       = ["Klaus Hartl"]
  spec.email         = ["kh@waymate.de"]
  spec.summary       = %q{Automate finding IATA codes from their search page.}
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "poltergeist"
  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
