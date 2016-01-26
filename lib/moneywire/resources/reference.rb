module Moneywire
  module Resources
    class Reference < BaseResource
      use_resource 'reference'

      def available_currencies
        get('available-currencies')
      end

      def currency_pairs
        get('currency-pairs')
      end

      def balances
        get('balances')
      end

      def settlement_accounts(conversion_id)
        get("settlement-accounts/#{conversion_id}")
      end

      def conversion_dates(**params)
        get('conversion-dates', params)
      end
    end
  end
end
