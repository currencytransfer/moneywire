require 'spec_helper'

describe 'Integration with conversions', vcr: true do
  let(:client) do
    SpecConfig.account.client_instance
  end

  let(:expected_response_fields) do
    %w(
      id
      status
      sellCurrency buyCurrency currencyPair
      fixedSide sellAmount buyAmount
      interbankRate clientRate commission
      settlementTime createdAt
    )
  end

  describe 'create' do
    it 'returns conversion details' do
      result = client.conversions.create(
        sellCurrency: 'GBP',
        buyCurrency: 'EUR',
        currencyPair: 'GBPEUR',
        deliveryDate: '2016-06-30',
        fixedSide: :sell,
        amount: 15_000,
        agreesToTerms: true
      )
      expect(result).to(include(*expected_response_fields))
    end

    context 'with invalid worstInterbankRate' do
      let(:response) do
        client.conversions.create(
          sellCurrency: 'EUR',
          buyCurrency: 'GBP',
          currencyPair: 'EURGBP',
          settlementDate: '2016-01-29',
          fixedSide: :sell,
          amount: 15_000,
          agreesToTerms: true,
          worstInterbankRate: 1.0
        )
      end

      it 'raises BadRequestError for invalid worstInterbankRate' do
        expect { response }.to(
          raise_error(Moneywire::BadRequestError)
        )
      end
    end

    context 'with invalid deliveryDate' do
      let(:response) do
        client.conversions.create(
          sellCurrency: 'GBP',
          buyCurrency: 'ILS',
          currencyPair: 'GBPILS',
          deliveryDate: '2016-01-01',
          fixedSide: :sell,
          amount: 15_000,
          agreesToTerms: true
        )
      end

      it 'raises BadRequestError for invalid deliveryDate' do
        expect { response }.to(
          raise_error(Moneywire::BadRequestError)
        )
      end
    end
  end

  describe 'retrieve' do
    it 'returns conversion details' do
      expect(client.conversions.retrieve(276)).to(
        include(*expected_response_fields)
      )
    end

    context 'when the conversion cannot be found' do
      it 'raises NotFoundError' do
        expect { client.conversions.retrieve(74_000) }.to(
          raise_error(Moneywire::NotFoundError)
        )
      end
    end
  end

  describe 'find' do
    let(:result) { client.conversions.find(buyCurrency: 'EUR') }

    it 'returns a list with conversions' do
      expect(result['conversions'].first).to include(*expected_response_fields)
    end

    it 'returns pagination information' do
      expect(result).to include(*%w(results page conversions))
    end
  end
end
