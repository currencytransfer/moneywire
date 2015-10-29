require 'spec_helper'

describe 'Integration with conversions', vcr: true do
  let(:client) do
    Moneywire::Client.new(SpecConfig.login_id, SpecConfig.api_key, SpecConfig.token)
  end

  let(:expected_response_fields) do
    %w(
      id
      status
      sellCurrency buyCurrency currencyPair
      fixedSide sellAmount buyAmount
      interbankRate clientRate commission
      settlementDate createdAt
    )
  end

  describe 'create' do
    it 'returns conversion details' do
      result = client.conversions.create(
        buyCurrency: 'EUR',
        sellCurrency: 'GBP',
        currencyPair: 'EURGBP',
        settlementDate: '2015-10-30',
        fixedSide: :sell,
        amount: 15_000,
        agreesToTerms: true,
        worstInterbankRate: 1.3951
      )
      expect(result).to(include(*expected_response_fields))
    end
  end

  describe 'retrieve' do
    it 'returns conversion details' do
      expect(client.conversions.retrieve(74)).to(
        include(*expected_response_fields)
      )
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
