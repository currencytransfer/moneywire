require 'spec_helper'

describe 'Integration with quotes', vcr: true do
  let(:client) do
    Moneywire::Client.new(*SpecConfig.account.credentials)
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
          settlementTime
          stale
        )
      end

      it 'accepts deliveryDate' do
        result = client.quotes.create(
          sellCurrency: 'EUR',
          buyCurrency: 'GBP',
          fixedSide: :sell,
          amount: 15_000,
          deliveryDate: '2016-02-16'
        )
        expect(result).to(include(*expected_response_fields))
      end
    end

    context 'with invalid arguments' do
      it 'raises NotFoundError for invalid currency pair' do
        args = {
          sellCurrency: 'ILS',
          buyCurrency: 'BGN',
          fixedSide: :sell,
          amount: 15_000,
          deliveryDate: '2016-01-29'
        }

        expect { client.quotes.create(args) }.to(
          raise_error(Moneywire::NotFoundError)
        )
      end

      it 'raises BadRequestError for not supported sell currency' do
        args = {
          sellCurrency: 'ILS',
          buyCurrency: 'EUR',
          fixedSide: :sell,
          amount: 15_000,
          deliveryDate: '2016-01-29'
        }

        expect { client.quotes.create(args) }.to(
          raise_error(Moneywire::BadRequestError)
        )
      end

      it 'raises BadRequestError for invalid amount' do
        args = {
          sellCurrency: 'EUR',
          buyCurrency: 'GBP',
          fixedSide: :sell,
          amount: 10,
          deliveryDate: '2016-01-29'
        }

        expect { client.quotes.create(args) }.to(
          raise_error(Moneywire::BadRequestError)
        )
      end

      it 'raises an error with information for buy_currency and amount' do
        args = {
          sellCurrency: 'EUR',
          buyCurrency: 'invalid-buy',
          fixedSide: :sell,
          amount: 'invalid'
        }
        expect { client.quotes.create(args) }.to(
          raise_error do |error|
            expect(error.response).to(
              include('code' => 'malformed_request_content', 'errors' => be_an(Array))
            )
          end
        )
      end

      it 'raises BadRequestError for invalid deliveryDate' do
        args = {
          sellCurrency: 'GBP',
          buyCurrency: 'ILS',
          fixedSide: :sell,
          amount: 15_000,
          deliveryDate: '2016-02-01'
        }

        expect { client.quotes.create(args) }.to(
          raise_error(Moneywire::BadRequestError)
        )
      end
    end

    context 'when the account is not activated' do
      let(:client) do
        Moneywire::Client.new(*SpecConfig.account_inactive.credentials)
      end

      let(:result) do
        client.quotes.create(
          sellCurrency: 'EUR',
          buyCurrency: 'GBP',
          fixedSide: :sell,
          amount: 15_000,
          deliveryDate: '2016-02-22'
        )
      end

      it 'it results in error' do
        expect { result }.to raise_error(Moneywire::AuthenticationError)
      end
    end
  end
end
