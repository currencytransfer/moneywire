require 'spec_helper'

describe 'Beneficiaries', vcr: true do
  let(:client) do
    SpecConfig.account.client_instance
  end

  let(:expected_response_fields) do
    %w(
      id
      bankAccountHolderName
      beneficiaryCountry
      bankCountry currency
      bicSwift
      iban
      bankAddress bankName
      beneficiaryEntityType beneficiaryCompanyName
      beneficiaryAddress beneficiaryCity beneficiaryPostcode
      beneficiaryStateOrProvince
      paymentType
    )
  end

  describe 'create' do
    let(:valid_beneficiary) do
      {
        bankAccountHolderName: 'John Smith',
        bankCountry: 'ES',
        currency: 'EUR',
        iban: 'ES9514650100981900000512',
        bicSwift: 'INGDESMM',
        beneficiaryEntityType: 'company',
        beneficiaryCountry: 'ES',
        beneficiaryCompanyName: 'Demo Inc.',
        beneficiaryAddress: '234 Demo Street Name',
        beneficiaryCity: 'New York',
        beneficiaryPostcode: 'NY123',
        beneficiaryStateOrProvince: 'NY',
        paymentType: 'both'
      }
    end

    it 'returns beneficiary details' do
      result = client.beneficiaries.create(valid_beneficiary)
      expect(result).to(include(*expected_response_fields))
    end

    context 'with invalid beneficiary details' do
      let(:invalid_beneficiary) do
        {
          bankAccountHolderName: 'John Smith',
          bankCountry: 'ES',
          currency: 'EUR',
          iban: 'invalid',
          bicSwift: 'INGDESMM',
          beneficiaryEntityType: 'company',
          beneficiaryCountry: 'ES',
          beneficiaryCompanyName: 'Demo Inc.',
          beneficiaryAddress: '234 Demo Street Name',
          beneficiaryCity: 'New York',
          beneficiaryPostcode: 'NY123',
          beneficiaryStateOrProvince: 'NY',
          paymentType: 'both'
        }
      end

      it 'returns beneficiary details' do
        expect { client.beneficiaries.create(invalid_beneficiary) }.to(
          raise_error(Moneywire::BadRequestError)
        )
      end
    end
  end

  describe 'update' do
    let(:valid_beneficiary) do
      {
        bankAccountHolderName: 'Mark',
        bankCountry: 'ES',
        currency: 'EUR',
        iban: 'ES9514650100981900000512',
        bicSwift: 'INGDESMM',
        beneficiaryEntityType: 'company',
        beneficiaryCountry: 'ES',
        beneficiaryCompanyName: 'Demo Inc.',
        beneficiaryAddress: '234 Demo Street Name',
        beneficiaryCity: 'New York',
        beneficiaryPostcode: 'NY123',
        beneficiaryStateOrProvince: 'NY',
        paymentType: 'both'
      }
    end

    it 'results in an error' do
      result = client.beneficiaries.update(165, valid_beneficiary)
      expect(result).to(include(*expected_response_fields))
    end

    context 'with invalid beneficiary details' do
      let(:invalid_beneficiary) do
        {
          bankAccountHolderName: 'Mark',
          bankCountry: 'ES',
          currency: 'EUR',
          bicSwift: 'INGDESMM',
          beneficiaryEntityType: 'company',
          beneficiaryCountry: 'ES',
          beneficiaryCompanyName: 'Demo Inc.',
          beneficiaryAddress: '234 Demo Street Name',
          beneficiaryCity: 'New York',
          beneficiaryPostcode: 'NY123',
          beneficiaryStateOrProvince: 'NY',
          paymentType: 'both'
        }
      end

      it 'results in an error' do
        expect { client.beneficiaries.update(165, invalid_beneficiary) }.to(
          raise_error(Moneywire::BadRequestError)
        )
      end
    end
  end

  describe 'retrieve' do
    it 'returns beneficiary details' do
      result = client.beneficiaries.retrieve(165)
      expect(result).to(include(*expected_response_fields))
    end

    context 'with invalid id' do
      it 'results in an error' do
        expect { client.beneficiaries.retrieve(1) }.to(
          raise_error(Moneywire::NotFoundError)
        )
      end
    end
  end

  describe 'find' do
    it 'returns beneficiary details' do
      result = client.beneficiaries.find(currency: 'EUR')
      expect(result['beneficiaries']).to all(include(*expected_response_fields))
    end
  end
end
