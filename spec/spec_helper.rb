if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-rcov'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::RcovFormatter
  ]

  SimpleCov.start do
    add_filter '/spec/'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'byebug'
require 'moneywire'
require 'vcr'

require File.expand_path('../support/config', __FILE__)

Moneywire.environment = :demo
SpecConfig.load

VCR.configure do |config|
  config.hook_into :webmock
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = {
    record: :new_episodes,
    allow_unused_http_interactions: false
  }
  config.configure_rspec_metadata!
end
