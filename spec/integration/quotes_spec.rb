require 'spec_helper'

describe 'Integration with quotes', vcr: true do
  let(:client) do
    Moneywire::Client.new(SpecConfig.login_id, SpecConfig.api_key, SpecConfig.token)
  end

  describe 'create' do
    context 'with valid arguments' do
      let(:expected_response_fields) do
        %w(
          sellAmount buyAmount
          commission transferFee
          markedUpAmount
          sellCurrency buyCurrency
          currencyPair
          fixedSide
          interbankRate clientRate markedUpRate
          quoteTime
          settlementDate
          stale
        )
      end

      it 'returns rate details' do
        result = client.quotes.create(
          sellCurrency: 'EUR',
          buyCurrency: 'GBP',
          fixedSide: :sell,
          amount: 15_000
        )
        expect(result).to(include(*expected_response_fields))
      end

      it 'accepts conversion_date' do
        result = client.quotes.create(
          sellCurrency: 'EUR',
          buyCurrency: 'GBP',
          fixedSide: :sell,
          amount: 15_000,
          settlementDate: '2015-10-29'
        )
        expect(result).to(include(*expected_response_fields))
      end
    end

    context 'with invalid arguments' do
      pending 'raises BadRequestError' do
        args = {
          sellCurrency: 'EUR',
          buyCurrency: 'GBP',
          fixedSide: :sell,
          amount: 0
        }
        expect { client.quotes.create(args) }.to(
          raise_error(Moneywire::BadRequestError)
        )
      end

      pending 'raises an error with information for buy_currency and amount' do
        args = {
          sellCurrency: 'EUR',
          buyCurrency: 'invalid-buy',
          fixedSide: :sell,
          amount: 'invalid'
        }
        expect { client.quotes.create(args) }.to(
          raise_error do |error|
            expect(error.response['error_messages']).to include('buy_currency', 'amount')
          end
        )
      end

      pending 'raises an error with information for base and amount' do
        args = {
          sellCurrency: 'EUR',
          buyCurrency: 'EUR',
          fixedSide: :sell,
          amount: 'invalid'
        }

        expect { client.quotes.create(args) }.to(
          raise_error do |error|
            expect(error.response['error_messages']).to include(
              'base', 'amount'
            )
          end
        )
      end
    end
  end
end
