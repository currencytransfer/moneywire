require 'moneywire/version'
require 'moneywire/client'

module Moneywire
  ENVIRONMENTS = {
    production: 'https://public-api.supercapital.uk/v1/',
    demo: 'https://public-demo-api.supercapital.uk/v1/'
  }

  class << self
    attr_reader :environment

    def environment=(value)
      validate_environment!(value)
      @environment = value.to_sym
    end

    def base_uri_for(env)
      validate_environment!(env)
      ENVIRONMENTS[env] || ENVIRONMENTS[:demo]
    end

    private

    def validate_environment!(value)
      return true if ENVIRONMENTS.keys.include?(value.to_sym)

      fail ArgumentError, "Invalid environment: `#{value}`, possible options: #{ENVIRONMENTS.keys}"
    end
  end
end
