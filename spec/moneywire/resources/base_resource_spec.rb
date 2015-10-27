require 'spec_helper'

class TestResource < Moneywire::Resources::BaseResource
  use_resource 'test'

  allow_actions :retrieve, :find, :update
end

describe Moneywire::Resources::BaseResource do
  let(:request_handler) { double.as_null_object }
  let(:test_resource) { TestResource.new(request_handler) }

  describe '.use_resource' do
    it 'sets the resource_name' do
      expect(TestResource.resource_name).to eq 'test'
    end
  end

  describe '.allow_actions' do
    it 'defines methods for the listed actions' do
      expect(test_resource.respond_to?(:retrieve)).to be true
    end

    context 'when unsupported action is used' do
      it 'results in a warning' do
        expect(TestResource).to receive(:warn).with('Warning: Unsupported action: not_supported')
        expect(TestResource).to receive(:warn).with('Warning: Unsupported action: not_ok')

        TestResource.allow_actions(:not_supported, :not_ok)
      end
    end
  end

  describe '#get' do
    it 'delegates to request_handler' do
      params = { param: 1 }
      options = { option: 1 }
      expect(request_handler).to receive(:get).with('test/action', params, options)
      test_resource.get('action', params, options)
    end
  end

  describe '#post' do
    it 'delegates to request_handler' do
      params = { param: 1 }
      options = { option: 1 }
      expect(request_handler).to receive(:post).with('test/action', params, options)
      test_resource.post('action', params, options)
    end
  end

  context 'when allowed actions are called' do
    context 'retrieve' do
      it 'delegates the request to the request_handler' do
        expect(request_handler).to(receive(:get).with(%r{test/some_id}, {}, {}))

        test_resource.retrieve('some_id')
      end
    end

    context 'find' do
      it 'delegates the request to the request_handler' do
        expect(request_handler).to(
          receive(:get).with(
            /test/,
            { status: 'awaiting_funds' },
            {}
          )
        )

        test_resource.find(status: 'awaiting_funds')
      end
    end

    context 'update' do
      it 'delegates the request to the request_handler' do
        expect(request_handler).to(
          receive(:post).with(%r{test/some_id}, { arg: 1, arg2: 'another' }, {})
        )

        test_resource.update('some_id', arg: 1, arg2: 'another')
      end
    end
  end
end
