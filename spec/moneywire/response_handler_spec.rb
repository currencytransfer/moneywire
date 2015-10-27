require 'spec_helper'

describe Moneywire::ResponseHandler do
  let(:response) do
    double('Response', code: 200, parsed_response: { 'success' => true })
  end
  let(:response_handler) { Moneywire::ResponseHandler.new(response) }

  describe '#parse' do
    context 'when successful response is received' do
      it 'returns the response body' do
        expect(response_handler.parse).to eq 'success' => true
      end
    end

    context 'when an error response is received' do
      [
        [400, Moneywire::BadRequestError],
        [401, Moneywire::AuthenticationError],
        [403, Moneywire::ForbiddenError],
        [404, Moneywire::NotFoundError],
        [500, Moneywire::InternalApplicationError],
        [501, Moneywire::UnknownError]
      ].each do |response_code, error|
        context "for response code: #{response_code}" do
          let(:response) do
            double(
              'Response',
              code: response_code,
              parsed_response: {
                'error_code' => 'some_error'
              }
            )
          end

          it "raises #{error}" do
            expect { response_handler.parse }.to raise_error(error)
          end
        end
      end
    end

    context 'when we have a BadRequestError' do
      let(:response) do
        double(
          'Response',
          code: 400,
          parsed_response: {
            'error_code' => 'some_error'
          }
        )
      end

      it 'attaches the parsed response to the error' do
        expect { response_handler.parse }.to raise_error do |error|
          expect(error.response).to include('error_code')
        end
      end
    end
  end
end
