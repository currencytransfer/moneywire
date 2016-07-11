require 'httparty'
require 'moneywire/response_handler'

module Moneywire
  class RequestHandler
    include HTTParty
    debug_output $stdout

    attr_reader :login_id, :api_key, :token, :token_renewed_block, :response_received_block,
                :environment

    def initialize(login_id, api_key, token, environment = nil)
      @login_id = login_id
      @api_key = api_key
      @token = token
      @environment = environment || Moneywire.environment
    end

    # Set a callback that will be called whenever a new token is generated
    # the block will receive the newly generated token as argument
    # e.g:
    #   handler.on_token_renewed do |new_token|
    #     # do something with the new token
    #   end
    def on_token_renewed(&block)
      @token_renewed_block = block
    end

    # Set a callback that will be called whenever an API response is received
    # the block will receive HTTParty response object and is_successful as arguments
    # e.g:
    #   handler.on_response_received do |response, is_successful|
    #     # log the response somewhere
    #   end
    def on_response_received(&block)
      @response_received_block = block
    end

    def get(uri, params = {}, options = {})
      options[:query] = params
      perform_request(:get, uri, options)
    end

    def post(uri, params = {}, options = {})
      options[:body] = params
      perform_request(:post, uri, options)
    end

    def put(uri, params = {}, options = {})
      options[:body] = params
      perform_request(:put, uri, options)
    end

    def delete(uri, params = {}, options = {})
      options[:query] = params
      perform_request(:delete, uri, options)
    end

    def authenticate
      params = { emailAddress: login_id, apiKey: api_key }.to_json
      @token = post('auth/api-login', params, retry_auth: false)['authToken']
      token_renewed_block.call(token) if token_renewed_block
      token
    end

    private

    def perform_request(method, uri, options)
      retry_auth = options[:retry_auth].nil? ? true : options.delete(:retry_auth)
      options[:headers] ||= {}
      if [:post, :put].include?(method)
        options[:headers]['Content-Type'] ||= 'application/json'
      end
      response_handler = retry_authentication(method, uri, options, retry_auth)
      response_handler.parse
    end

    def auth_headers
      headers = self.class.headers
      headers['X-Auth-Token'] = token if token
      headers
    end

    def retry_authentication(method, uri, options, retry_auth)
      response_handler = nil
      2.times do
        options[:headers].merge!(auth_headers)
        response = self.class.send(method, full_uri(uri), options)
        response_handler = ResponseHandler.new(response)

        call_response_received_block(response_handler)

        return response_handler if response_handler.authenticated? || !retry_auth
        authenticate
      end
      response_handler
    end

    def call_response_received_block(response_handler)
      return unless response_received_block
      response_received_block.call(
        response_handler.response,
        response_handler.successful?
      )
    end

    def full_uri(uri)
      return uri if %r{^https?://} =~ uri
      Moneywire.base_uri_for(@environment) + uri
    end
  end
end
