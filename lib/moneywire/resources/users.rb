module Moneywire
  module Resources
    class Users < BaseResource
      use_resource 'users'

      allow_actions :retrieve, :find, :create
    end
  end
end
