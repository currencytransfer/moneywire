require 'moneywire/request_handler'
require 'moneywire/resources/base_resource'
Dir[File.expand_path('../resources/*.rb', __FILE__)].each do |file|
  require file
end

module Moneywire
  class Client
    extend Forwardable

    attr_reader :request_handler
    delegate [:get, :post, :on_token_renewed, :on_response_received, :token] => :request_handler

    def initialize(login_id, api_key, token = nil, environment = nil)
      @request_handler = RequestHandler.new(login_id, api_key, token, environment)
      request_handler.authenticate if token.nil?
    end
  end
end
