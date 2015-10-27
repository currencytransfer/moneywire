module Moneywire
  module Resources
    class BaseResource
      def initialize(request_handler)
        @request_handler = request_handler
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
        get(id.to_s)
      end

      def perform_find(**optional)
        get('', optional)
      end

      def perform_update(id, **optional)
        post(id.to_s, optional)
      end
    end
  end
end
