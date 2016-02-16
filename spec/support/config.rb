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
        config["TOKEN#{suffix}"] || 'token'
      )
    end
  end

  class Account
    attr_reader :login_id, :api_key, :token

    def initialize(login_id, api_key, token)
      @login_id = login_id
      @api_key = api_key
      @token = token
    end

    def credentials
      [login_id, api_key, token]
    end
  end
end
