lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prometheus/collector/version'

Gem::Specification.new do |spec|
  spec.name = 'prometheus-collector'
  spec.version = Prometheus::Collector::VERSION
  spec.authors = ['Stuart Harland']
  spec.email   = ['essjayhch@gmail.com']

  spec.summary  = 'Scaffold to collect prometheus style metrics from an application via a RACK interface'
  spec.description = spec.summary

  spec.homepage = 'https://github.com/essjayhch/prometheus-collector'
  spec.license = 'MIT'

  spec.files =`git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']
  spec.executables << 'prometheus-collector'

  spec.add_dependency  'prometheus-client', '> 0'
  spec.add_dependency  'puma', '> 0'
  spec.add_dependency  'rack', '> 0'
  spec.add_dependency  'register', '> 0'
  spec.add_dependency  'em-cron', '> 0'

  spec.add_development_dependency 'fileutils'
end
