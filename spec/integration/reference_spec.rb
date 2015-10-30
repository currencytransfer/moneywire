require 'spec_helper'

describe 'Integration with reference', vcr: true do
  let(:client) do
    Moneywire::Client.new(SpecConfig.login_id, SpecConfig.api_key, SpecConfig.token)
  end

  describe 'settlement_accounts' do
    let(:expected_response_fields) do
      %w(
        accountType
        currency
        accountName
        beneficiaryName
        beneficiaryAddress beneficiaryCountry
        bankName bankCountry
        bicSwift iban routingCode accountNumber
      )
    end
    it 'returns settlement account information' do
      expect(client.reference.settlement_accounts('USD')).to include(*expected_response_fields)
    end
  end
end
