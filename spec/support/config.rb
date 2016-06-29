module SpecConfig
  class << self
    attr_reader :account, :account_inactive

    def load
      config = {}
      begin
        config = YAML.load_file('spec/env.yml')
      rescue
        warn 'Warning: Unable to load config file. ' \
             'Make sure you have a valid: spec/env.yml, ' \
             'if/when you need to do real requests to the demo api.'
      end

      @account = init_account(config)

      @account_inactive = init_account(config, '_INACTIVE')
    end

    def init_account(config, suffix = '')
      Account.new(
        config["LOGIN_ID#{suffix}"] || 'login_id',
        config["API_KEY#{suffix}"] || 'api_key',
        config["TOKEN#{suffix}"] || 'token',
        config["TOTP_TOKEN#{suffix}"] || 'totp_token',
        config["ACTING_FOR#{suffix}"] || 'acting_for'
      )
    end
  end

  class Account
    attr_reader :login_id, :api_key, :token, :totp_token, :acting_for

    def initialize(login_id, api_key, token, totp_token, acting_for)
      @login_id = login_id
      @api_key = api_key
      @token = token
      @totp_token = totp_token
      @acting_for = acting_for
    end

    def client_instance
      Moneywire::Client.new(
        login_id,
        api_key,
        token: token,
        totp_token: totp_token,
        acting_for: acting_for
      )
    end
  end
end
