# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moneywire/version'

Gem::Specification.new do |spec|
  spec.name          = 'moneywire'
  spec.version       = Moneywire::VERSION
  spec.authors       = ['CurrencyTransfer.com']
  spec.email         = ['kamen@currencytransfer.com']

  spec.summary       = 'An API wrapper for Moneywire'
  spec.homepage      = 'https://github.com/currencytransfer/moneywire'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.2'
  spec.required_rubygems_version = '>= 1.3.5'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.32'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'simplecov', '~> 0.10'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2'
  spec.add_development_dependency 'byebug'

  spec.add_runtime_dependency 'httparty', '>= 0.13'
  spec.add_runtime_dependency 'rotp', '>= 3.1.0'
end
