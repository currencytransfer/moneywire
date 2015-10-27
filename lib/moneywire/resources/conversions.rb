module Moneywire
  module Resources
    class Conversions < BaseResource
      use_resource 'conversions'
      allow_actions :retrieve, :find, :create
    end
  end
end
