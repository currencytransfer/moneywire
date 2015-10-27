module SpecConfig
  class << self
    attr_reader :login_id, :api_key, :token

    def load
      config = {}
      begin
        config = YAML.load_file('spec/env.yml')
      rescue
        warn 'Warning: Unable to load config file. ' \
             'Make sure you have a valid: spec/env.yml, ' \
             'if/when you need to do real requests to the demo api.'
      end
      @login_id = config['LOGIN_ID'] || 'login_id'
      @api_key = config['API_KEY'] || 'api_key'
      @token = config['TOKEN'] || 'token'
    end
  end
end
