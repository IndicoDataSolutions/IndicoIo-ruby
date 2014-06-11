# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'indico/version'

Gem::Specification.new do |spec|
  spec.name          = "indico"
  spec.version       = Indico::VERSION
  spec.authors       = ["Amit Ambardekar"]
  spec.email         = ["amitamb@gmail.com"]
  spec.summary       = %q{Ruby gem for for Indico API.}
  spec.description   = %q{Ruby gem for for Indico API.}
  spec.homepage      = "https://github.com/IndicoDataSolutions/IndicoIo-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
