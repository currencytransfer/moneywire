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

      def settlement_accounts(currency)
        get("settlement-accounts/#{currency}")
      end

      def invalid_conversion_dates(currency_pair)
        get("invalid-conversion-dates/#{currency_pair}")
      end
    end
  end
end
