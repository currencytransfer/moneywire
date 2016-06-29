require 'spec_helper'

describe 'Users', vcr: true do
  let(:client) do
    SpecConfig.account.client_instance
  end

  let(:expected_response_fields) do
    %w(
      id loginId
      active tradingEnabled
      isCompany
      firstName lastName mobileNumber
      nationality dateOfBirth
      street city postalCode country
      confirmationEmailAddress
    )
  end

  describe 'find' do
    let(:result) { client.users.find(loginId: 'kamen+demo@currencytransfer.com') }

    it 'returns a list with users' do
      expect(result['users']).to all include(*expected_response_fields)
    end

    it 'returns pagination information' do
      expect(result).to include(*%w(results page users))
    end
  end

  describe 'retrieve' do
    it 'returns users details' do
      expect(client.users.retrieve(148)).to(include(*expected_response_fields))
    end
  end
end
