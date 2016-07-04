module Moneywire
  module Resources
    class Beneficiaries < BaseResource
      use_resource 'beneficiaries'

      allow_actions :retrieve, :find

      def create(**optional)
        perform_create({ beneficiary: optional }.merge(totp_params))
      end

      def update(id, **optional)
        perform_update(id, { beneficiary: optional }.merge(totp_params))
      end
    end
  end
end
