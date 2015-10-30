module Moneywire
  module Resources
    class Reference < BaseResource
      use_resource 'reference'

      def settlement_accounts(currency)
        get("settlement-accounts/#{currency}")
      end
    end
  end
end
