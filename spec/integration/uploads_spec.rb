require 'spec_helper'

describe 'Uploads', vcr: true do
  let(:client) do
    SpecConfig.account.client_instance
  end

  it 'uploads a file successfully' do
    response = client.uploads.required_documents(
      'proof-of-id', 'spec/fixtures/test_upload.png'
    )
    expect(response).to eq 'The document has been uploaded successfully.'
  end
end
