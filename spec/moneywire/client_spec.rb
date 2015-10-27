require 'spec_helper'

describe Moneywire::Client do
  let(:client) { Moneywire::Client.new('login_id', 'api_key', 'token') }

  describe '.new' do
    it 'creates a RequestHandler instance' do
      expect(Moneywire::RequestHandler).to receive(:new).with('login_id', 'api_key', 'token', nil)
      Moneywire::Client.new('login_id', 'api_key', 'token')
    end

    context 'when a no authentication token is provided' do
      let(:request_handler) { double(Moneywire::RequestHandler) }

      before do
        allow(Moneywire::RequestHandler).to receive(:new).and_return(request_handler)
      end

      it 'requests authentication' do
        expect(request_handler).to receive(:authenticate)
        Moneywire::Client.new('login_id', 'api_key')
      end
    end

    context 'when a authentication token is provided' do
      let(:request_handler) { double(Moneywire::RequestHandler) }

      before do
        allow(Moneywire::RequestHandler).to receive(:new).and_return(request_handler)
      end

      it 'does not request authentication' do
        expect(request_handler).not_to receive(:authenticate)
        Moneywire::Client.new('login_id', 'api_key', 'my_token')
      end
    end
  end
end
