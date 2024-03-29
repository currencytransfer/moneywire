require 'spec_helper'

describe 'Reference', vcr: true do
  let(:client) do
    SpecConfig.account.client_instance
  end

  describe 'available_currencies' do
    it 'returns an array with information for the available currencies' do
      expect(client.reference.available_currencies).to all include(
        'code', 'name', 'localPaymentAvailable', 'cutOffTime', 'priorityDelivery',
        'availableBuy', 'availableSell'
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
        boughtFunds
        settledBoughtFunds
        unsettledBoughtFunds
        deposits
        payments
        deductions
        balance
        availableToWithdraw
        transactionLimit
      )
    end

    it 'returns current balance information' do
      expect(result['balances']).to all include(*expected_fields)
    end

    context 'when requesting a specific currency' do
      let(:result) { client.reference.balances('AUD') }

      it 'returns current balance information' do
        expect(result).to include(*expected_fields)
      end
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
      expect(client.reference.settlement_accounts(276)).to include(*expected_fields)
    end
  end

  describe 'conversion_dates' do
    it 'returns information for invalid conversion dates' do
      result = client.reference.conversion_dates(
        sellCurrency: 'GBP',
        buyCurrency: 'USD'
      )
      expect(result).to(
        include(
          'invalidConversionDates',
          'firstSettlementDate',
          'firstConversionDate',
          'firstDeliveryDate'
        )
      )
    end
  end
end
