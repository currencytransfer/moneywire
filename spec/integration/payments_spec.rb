require 'spec_helper'

describe 'Payments', vcr: true do
  let(:client) do
    SpecConfig.account.client_instance
  end

  let(:expected_response_fields) do
    %w(
      id
      beneficiaryId
      amount currency
      paymentDate
      paymentType
      reason
      reference
      status
      transferFeeCurrency
    )
  end

  describe 'create' do
    let(:valid_payment) do
      {
        beneficiaryId: 165,
        amount: 10_000,
        currency: 'EUR',
        paymentDate: '2016-07-04',
        paymentType: 'local',
        reason: 'property',
        reference: 'Apartment 123',
        transferFeeCurrency: 'GBP'
      }
    end

    it 'returns payment details' do
      result = client.payments.create(valid_payment)
      expect(result).to(include(*expected_response_fields))
    end
  end

  describe 'update' do
    let(:valid_payment) do
      {
        beneficiaryId: 165,
        amount: 2_000,
        currency: 'EUR',
        paymentDate: '2016-07-04',
        paymentType: 'local',
        reason: 'property',
        reference: 'Apartment 123',
        transferFeeCurrency: 'GBP'
      }
    end

    it 'returns payment details' do
      result = client.payments.update(27, valid_payment)
      expect(result).to(include(*expected_response_fields))
    end
  end

  describe 'retrieve' do
    it 'returns payment details' do
      result = client.payments.retrieve(27)
      expect(result).to(include(*expected_response_fields))
    end
  end

  describe 'find' do
    it 'returns a list with payment details' do
      result = client.payments.find(currency: 'EUR')
      expect(result['payments']).to all(include(*expected_response_fields))
    end
  end

  describe 'delete' do
    it 'returns payment details' do
      result = client.payments.delete(28)
      expect(result).to eq 'Payment deleted'
    end
  end
end
