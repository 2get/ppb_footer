# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ppb_footer/version'

Gem::Specification.new do |spec|
  spec.name          = "ppb_footer"
  spec.version       = PpbFooter::VERSION
  spec.authors       = ["YOSHIDA Mayoto", "SHIBATA Hiroshi"]
  spec.email         = ["2getjp@gmail.com", "shibata.hiroshi@gmail.com"]
  spec.description   = %q{footer helpers of paperboy&co.}
  spec.summary       = %q{footer helpers of paperboy&co.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
