require 'spec_helper'

class TestResource < Moneywire::Resources::BaseResource
  use_resource 'test'

  allow_actions :retrieve, :find, :update, :create
end

describe Moneywire::Resources::BaseResource do
  let(:request_handler) { double.as_null_object }
  let(:test_resource) { TestResource.new(request_handler) }
  let(:test_resource_acting_for) { TestResource.new(request_handler, acting_for: 1) }

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
      expect(request_handler).to receive(:post).with('test/action', params.to_json, options)
      test_resource.post('action', params, options)
    end
  end

  describe '#put' do
    it 'delegates to request_handler' do
      params = { param: 1 }
      options = { option: 1 }
      expect(request_handler).to receive(:put).with('test/action', params.to_json, options)
      test_resource.put('action', params, options)
    end
  end

  context 'when allowed actions are called' do
    context 'retrieve' do
      it 'delegates the request to the request_handler' do
        expect(request_handler).to(receive(:get).with(%r{test/some_id}, {}, {}))

        test_resource.retrieve('some_id')
      end

      context 'with acting_for set' do
        it 'adds actingFor parameter' do
          expect(request_handler).to(
            receive(:get).with(%r{test/some_id}, { actingFor: 1 }, {})
          )

          test_resource_acting_for.retrieve('some_id')
        end
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

      context 'with acting_for set' do
        it 'adds actingFor parameter' do
          expect(request_handler).to(
            receive(:get).with(
              /test/,
              { actingFor: 1, status: 'awaiting_funds' },
              {}
            )
          )

          test_resource_acting_for.find(status: 'awaiting_funds')
        end
      end
    end

    context 'update' do
      it 'delegates the request to the request_handler' do
        expect(request_handler).to(
          receive(:put).with(%r{test/some_id}, { arg: 1, arg2: 'another' }.to_json, {})
        )

        test_resource.update('some_id', arg: 1, arg2: 'another')
      end

      context 'with acting_for set' do
        it 'adds actingFor parameter' do
          expect(request_handler).to(
            receive(:put).with(
              %r{test/some_id},
              { arg: 1, arg2: 'another', actingFor: 1 }.to_json,
              {}
            )
          )

          test_resource_acting_for.update('some_id', arg: 1, arg2: 'another')
        end
      end
    end

    context 'create' do
      it 'delegates the request to the request_handler' do
        expect(request_handler).to(
          receive(:post).with('test/', { arg: 1, arg2: 'another' }.to_json, {})
        )

        test_resource.create(arg: 1, arg2: 'another')
      end

      context 'with acting_for set' do
        it 'adds actingFor parameter' do
          expect(request_handler).to(
            receive(:post).with(
              'test/',
              { arg: 1, arg2: 'another', actingFor: 1 }.to_json,
              {}
            )
          )

          test_resource_acting_for.create(arg: 1, arg2: 'another')
        end
      end
    end
  end
end
