require 'spec_helper'

describe 'Integration with reference', vcr: true do
  let(:client) do
    Moneywire::Client.new(SpecConfig.login_id, SpecConfig.api_key, SpecConfig.token)
  end

  describe 'available_currencies' do
    it 'returns an array with information for the available currencies' do
      expect(client.reference.available_currencies).to all include(
        'code', 'name', 'localPaymentAvailable', 'cutOffTime', 'priorityDelivery',
        'availableBuy', 'availableSell', 'extendedAvailableBuy', 'extendedAvailableSell'
      )
    end
  end

  describe 'currency_pairs' do
    it 'returns an array currency pairs' do
      expect(client.reference.currency_pairs).to all match(/\A[A-Z]{6}\Z/)
    end
  end

  describe 'balances' do
    let(:result) { client.reference.balances }
    let(:expected_fields) do
      %w(
        currency
        settledFunds
        deposits
        payments
        deductions
        availableToWithdraw
        transactionLimit
      )
    end

    it 'returns current balance information' do
      expect(client.reference.balances['balances']).to all include(*expected_fields)
    end
  end

  describe 'settlement_accounts' do
    let(:expected_fields) do
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
      expect(client.reference.settlement_accounts(132)).to include(*expected_fields)
    end
  end

  describe 'invalid_conversion_dates' do
    it 'returns information for invalid conversion dates' do
      expect(client.reference.invalid_conversion_dates('GBPUSD')).to(
        include(
          'invalid_conversion_dates',
          'first_conversion_date',
          'default_conversion_date'
        )
      )
    end
  end
end
