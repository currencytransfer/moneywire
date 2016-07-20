require 'spec_helper'

describe Moneywire::RequestHandler do
  let(:response_200) { double('Response', code: 200, parsed_response: {}) }
  let(:response_401) { double('Response', code: 401, parsed_response: {}) }
  let(:response_auth) do
    double('Response', code: 200, parsed_response: { 'authToken' => 'some_token' })
  end

  let(:request_handler) do
    Moneywire::RequestHandler.new(
      'ct@ct.com',
      '1234',
      'token_string'
    )
  end

  before do
    allow(Moneywire::RequestHandler).to(
      receive(:post).with(%r{auth/api-login}, anything).and_return(response_auth)
    )
  end

  describe '#get' do
    context 'with a valid authentication token' do
      it 'delegates to Moneywire::RequestHandler.get' do
        allow(Moneywire::RequestHandler).to receive(:get).once do |uri, options|
          expect(uri).to include('beneficiaries')
          expect(options).to include(
            query: { name: 'john' },
            headers: {
              'X-Auth-Token' => 'token_string',
              'User-Agent' => 'in_a_rest'
            }
          )
          response_200
        end
        request_handler.get(
          'beneficiaries', { name: 'john' }, headers: { 'User-Agent' => 'in_a_rest' }
        )
      end
    end

    context 'with invalid authentication token' do
      before do
        allow(Moneywire::RequestHandler).to(
          receive(:get).and_return(response_401, response_200)
        )
      end

      it 'attempts to re-authenticate' do
        expect(Moneywire::RequestHandler).to(
          receive(:post).with(/api-login/, anything)
        )
        request_handler.get('beneficiaries', name: 'john')
      end

      it 'calls the original request two times' do
        expect(Moneywire::RequestHandler).to(
          receive(:get).with(/beneficiaries/, anything).exactly(2).times
        )
        request_handler.get('beneficiaries', name: 'john')
      end

      context 'when the authentication fails twice' do
        before do
          allow(Moneywire::RequestHandler).to(
            receive(:get).and_return(response_401, response_401)
          )
        end

        it 'calls the original request two times' do
          expect(Moneywire::RequestHandler).to(
            receive(:get).with(/beneficiaries/, anything).exactly(2).times
          )

          expect { request_handler.get('beneficiaries', name: 'john') }.to(
            raise_error(Moneywire::AuthenticationError)
          )
        end
      end
    end

    context 'when there is a on_response_received handler set' do
      before do
        allow(Moneywire::RequestHandler).to receive(:get).and_return(response_200)

        request_handler.on_response_received do |response, is_successfull|
          [response, is_successfull]
        end
      end

      it 'calls the handler' do
        expect(request_handler.response_received_block).to(
          receive(:call).with(response_200, true)
        )
        request_handler.get('some_resource')
      end
    end
  end

  describe '#post' do
    context 'with valid authentication token' do
      it 'delegates to Moneywire::RequestHandler.post' do
        allow(Moneywire::RequestHandler).to receive(:post) do |uri, options|
          expect(uri).to include('beneficiaries')
          expect(options).to include(
            body: { name: 'john' }.to_json,
            headers: {
              'X-Auth-Token' => 'token_string',
              'Content-Type' => 'application/json',
              'User-Agent' => 'in_a_rest'
            }
          )
          response_200
        end
        request_handler.post(
          'beneficiaries', { name: 'john' }.to_json, headers: { 'User-Agent' => 'in_a_rest' }
        )
      end
    end

    context 'with invalid authentication token' do
      before do
        allow(Moneywire::RequestHandler).to(
          receive(:post).with(/bene/, anything).and_return(response_401, response_200)
        )
      end

      after { request_handler.post('beneficiary', name: 'john') }

      it 'attempts to re-authenticate' do
        expect(Moneywire::RequestHandler).to receive(:post).with(/api-login/, anything)
      end

      it 'calls the original request two times' do
        expect(Moneywire::RequestHandler).to(
          receive(:post).with(/beneficiary/, anything).exactly(2).times
        )
      end
    end

    context 'when there is a on_response_received handler set' do
      before do
        allow(Moneywire::RequestHandler).to receive(:post).and_return(response_200)

        request_handler.on_response_received do |response, is_successfull|
          [response, is_successfull]
        end
      end

      it 'calls the handler' do
        expect(request_handler.response_received_block).to(
          receive(:call).with(response_200, true)
        )
        request_handler.post('some_resource')
      end
    end
  end

  describe '#put' do
    context 'with valid authentication token' do
      it 'delegates to Moneywire::RequestHandler.post' do
        allow(Moneywire::RequestHandler).to receive(:put) do |uri, options|
          expect(uri).to include('beneficiaries/1')
          expect(options).to include(
            body: { name: 'john' }.to_json,
            headers: {
              'X-Auth-Token' => 'token_string',
              'Content-Type' => 'application/json',
              'User-Agent' => 'in_a_rest'
            }
          )
          response_200
        end
        request_handler.put(
          'beneficiaries/1', { name: 'john' }.to_json, headers: { 'User-Agent' => 'in_a_rest' }
        )
      end
    end

    context 'with invalid authentication token' do
      before do
        allow(Moneywire::RequestHandler).to(
          receive(:put).with(/bene/, anything).and_return(response_401, response_200)
        )
      end

      after { request_handler.put('beneficiary/1', name: 'john') }

      it 'attempts to re-authenticate' do
        expect(Moneywire::RequestHandler).to receive(:post).with(/api-login/, anything)
      end

      it 'calls the original request two times' do
        expect(Moneywire::RequestHandler).to(
          receive(:put).with(/beneficiary/, anything).exactly(2).times
        )
      end
    end

    context 'when there is a on_response_received handler set' do
      before do
        allow(Moneywire::RequestHandler).to receive(:put).and_return(response_200)

        request_handler.on_response_received do |response, is_successfull|
          [response, is_successfull]
        end
      end

      it 'calls the handler' do
        expect(request_handler.response_received_block).to(
          receive(:call).with(response_200, true)
        )
        request_handler.put('some_resource')
      end
    end
  end

  describe '#delete' do
    it 'delegates to Moneywire::RequestHandler.delete' do
      allow(Moneywire::RequestHandler).to receive(:delete).once do |uri, options|
        expect(uri).to include('beneficiaries')
        expect(options).to include(
          query: { name: 'john' },
          headers: {
            'X-Auth-Token' => 'token_string',
            'User-Agent' => 'in_a_rest'
          }
        )
        response_200
      end
      request_handler.delete(
        'beneficiaries', { name: 'john' }, headers: { 'User-Agent' => 'in_a_rest' }
      )
    end
  end

  describe '#authenticate' do
    it 'delegates to `post`' do
      expect(request_handler).to(
        receive(:post).with(
          'auth/api-login',
          { emailAddress: 'ct@ct.com', apiKey: '1234' }.to_json,
          retry_auth: false
        ).and_call_original
      )

      request_handler.authenticate
    end

    it 'returns the new authentication token' do
      expect(request_handler.authenticate).to eq 'some_token'
    end

    context 'when there is an on_token_renewed handler set' do
      before do
        request_handler.on_token_renewed do |token|
          token
        end
      end

      it 'calls the handler' do
        expect(request_handler.token_renewed_block).to(
          receive(:call).with('some_token')
        )
        request_handler.authenticate
      end
    end
  end
end
