module Moneywire
  module Resources
    class Payments < BaseResource
      use_resource 'payments'

      allow_actions :create, :update, :retrieve, :find

      def delete(id)
        request_handler.delete("payments/#{id}", include_acting_for({}))
      end
    end
  end
end
