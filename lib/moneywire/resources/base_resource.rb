module Moneywire
  module Resources
    class BaseResource
      attr_reader :totp_token, :acting_for

      def initialize(request_handler, totp_token: nil, acting_for: nil)
        @request_handler = request_handler
        @acting_for = acting_for
        @totp_token = totp_token
      end

      class << self
        attr_reader :resource_name

        def use_resource(name)
          @resource_name = name
        end

        def allow_actions(*actions)
          actions.each do |action|
            alias_to = "perform_#{action}".to_sym
            if method_defined?(alias_to)
              alias_method action, alias_to
              public action
            else
              warn "Warning: Unsupported action: #{action}"
            end
          end
        end
      end

      def get(uri, params = {}, options = {})
        request_handler.get("#{self.class.resource_name}/#{uri}", params, options)
      end

      def post(uri, params = {}, options = {})
        request_handler.post("#{self.class.resource_name}/#{uri}", params, options)
      end

      protected

      attr_reader :request_handler

      def perform_retrieve(id)
        get(id.to_s, include_acting_for({}))
      end

      def perform_find(**optional)
        get('', include_acting_for(optional))
      end

      def perform_update(id, **optional)
        post(id.to_s, include_acting_for(optional))
      end

      def perform_create(**optional)
        post('', include_acting_for(optional))
      end

      def include_acting_for(params)
        params[:actingFor] = acting_for if acting_for
        params
      end
    end
  end
end
