require 'spec_helper'

describe Moneywire::Client do
  let(:client) do
    described_class.new(
      'login_id', 'api_key',
      token: 'token', totp_token: 'totp', acting_for: 1
    )
  end

  describe '.new' do
    it 'creates a RequestHandler instance' do
      expect(Moneywire::RequestHandler).to receive(:new).with('login_id', 'api_key', 'token', nil)
      described_class.new(
        'login_id', 'api_key',
        token: 'token', totp_token: 'totp', acting_for: 1
      )
    end

    context 'when a no authentication token is provided' do
      let(:request_handler) { double(Moneywire::RequestHandler) }

      before do
        allow(Moneywire::RequestHandler).to receive(:new).and_return(request_handler)
      end

      it 'requests authentication' do
        expect(request_handler).to receive(:authenticate)
        described_class.new(
          'login_id', 'api_key', totp_token: 'totp', acting_for: 1
        )
      end
    end

    context 'when a authentication token is provided' do
      let(:request_handler) { double(Moneywire::RequestHandler) }

      before do
        allow(Moneywire::RequestHandler).to receive(:new).and_return(request_handler)
      end

      it 'does not request authentication' do
        expect(request_handler).not_to receive(:authenticate)
        described_class.new(
          'login_id', 'api_key',
          token: 'token', totp_token: 'totp', acting_for: 1
        )
      end
    end
  end

  describe '#quotes' do
    it 'creates a resource instance passing acting_for parameter' do
      expect(Moneywire::Resources::Quotes).to receive(:new).with(
        client.request_handler,
        acting_for: 1
      )

      client.quotes
    end
  end

  describe '#conversions' do
    it 'creates a resource instance passing acting_for parameter' do
      expect(Moneywire::Resources::Conversions).to receive(:new).with(
        client.request_handler,
        acting_for: 1
      )

      client.conversions
    end
  end

  describe '#reference' do
    it 'creates a resource instance passing acting_for parameter' do
      expect(Moneywire::Resources::Reference).to receive(:new).with(
        client.request_handler,
        acting_for: 1
      )

      client.reference
    end
  end
end
