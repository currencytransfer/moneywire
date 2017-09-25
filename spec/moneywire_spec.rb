require 'spec_helper'

describe Moneywire do
  it 'has a version number' do
    expect(Moneywire::VERSION).not_to be nil
  end

  describe '.environment=' do
    it 'fails if invalid environment is specified' do
      expect { Moneywire.environment = :something_invalid }.to raise_error(ArgumentError)
    end
  end

  describe '.base_uri_for' do
    it 'return uri for specified environment' do
      expect(Moneywire.base_uri_for(:production)).to(
        eq('https://currencytransfer-api.supercapital.uk/v1/')
      )
    end
  end
end
