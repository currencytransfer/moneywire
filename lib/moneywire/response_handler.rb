require 'moneywire/errors'

module Moneywire
  class ResponseHandler
    attr_reader :response

    def initialize(httparty_response)
      @response = httparty_response
    end

    def parse
      return response.parsed_response if successful?

      fail map_error
    end

    def successful?
      (200..206).cover?(response.code)
    end

    def authenticated?
      response.code != 401
    end

    private

    def map_error # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
      error =
        case response.code
          when 400 then BadRequestError.new('Bad request', response.parsed_response)
          when 401 then AuthenticationError.new('Invalid credentials')
          when 403 then ForbiddenError.new(
            'No permissions to access requested resource',
            response.parsed_response
          )
          when 404 then NotFoundError.new(
            'Requested resource is not found', response.parsed_response
          )
          when 500 then InternalApplicationError.new(
            'Something is wrong with Moneywire server'
          )
        end
      error ? error : UnknownError.new('Unrecognized server response')
    end
  end
end
