require 'moneywire/request_handler'
require 'moneywire/resources/base_resource'
Dir[File.expand_path('../resources/*.rb', __FILE__)].each do |file|
  require file
end

module Moneywire
  class Client
    extend Forwardable

    attr_reader :request_handler, :acting_for, :totp_token
    delegate [:get, :post, :on_token_renewed, :on_response_received, :token] => :request_handler

    def initialize(login_id, api_key,
                   token: nil, totp_token: nil, acting_for: nil, environment: nil)
      @request_handler = RequestHandler.new(
        login_id, api_key, token, environment
      )
      @totp_token = totp_token
      @acting_for = acting_for.to_i
      request_handler.authenticate if token.nil?
    end

    def quotes
      @quotes ||= Resources::Quotes.new(request_handler, acting_for: acting_for)
    end

    def conversions
      @conversions ||= Resources::Conversions.new(request_handler, acting_for: acting_for)
    end

    def users
      # these requests are only available to master accounts,
      # so no acting_for is supposed to be used
      @users ||= Resources::Users.new(request_handler)
    end

    def beneficiaries
      @beneficiaries ||= Resources::Beneficiaries.new(
        request_handler,
        acting_for: acting_for,
        totp_token: totp_token
      )
    end

    def payments
      @payments ||= Resources::Payments.new(request_handler, acting_for: acting_for)
    end

    def reference
      @reference ||= Resources::Reference.new(request_handler, acting_for: acting_for)
    end

    def uploads
      @uploads ||= Resources::Uploads.new(request_handler, acting_for: acting_for)
    end
  end
end
