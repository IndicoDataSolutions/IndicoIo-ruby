# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'indico/version'

Gem::Specification.new do |spec|
  spec.name          = 'indico'
  spec.version       = Indico::VERSION
  spec.authors       = ['Slater Victoroff', 'Amit Ambardekar', 'Madison May', 'Annie Carlson']
  spec.email         = ['slater@indico.io', 'amitamb@gmail.com', 'madison@indico.io', 'annie@indico.io']
  spec.summary       = 'A simple Ruby Wrapper for the indico set of APIs.'
  spec.description   = 'A simple Ruby Wrapper for the indico set of APIs.'
  spec.homepage      = 'https://github.com/IndicoDataSolutions/IndicoIo-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep('^bin\\/') { |f| File.basename(f) }
  spec.test_files    = spec.files.grep('^(test|spec|features)\\/')
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'inifile', '~> 3.0.0'
  spec.add_runtime_dependency 'oily_png', '~> 1.2.0'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

end
