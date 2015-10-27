module Moneywire
  module Resources
    class Quotes < BaseResource
      use_resource 'quotes'
      allow_actions :create
    end
  end
end
