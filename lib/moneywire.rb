require 'moneywire/version'
require 'moneywire/client'

module Moneywire
  ENVIRONMENTS = {
    production: 'https://public-api.supercapital.uk/v1/',
    demo: 'https://public-demo-api.supercapital.uk/v1/'
  }.freeze

  FILE_UPLOADS = {
    production: 'https://file.supercapital.uk/v1/',
    demo: 'https://file-demo.supercapital.uk/v1/'
  }.freeze

  class << self
    attr_reader :environment

    def environment=(value)
      validate_environment!(value)
      @environment = value.to_sym
    end

    def base_uri_for(env)
      ENVIRONMENTS[env] || validate_environment!(value)
    end

    def file_upload_uri_for(env)
      FILE_UPLOADS[env] || validate_environment!(value)
    end

    private

    def validate_environment!(value)
      return true if ENVIRONMENTS.keys.include?(value.to_sym)

      fail ArgumentError, "Invalid environment: `#{value}`, possible options: #{ENVIRONMENTS.keys}"
    end
  end
end
