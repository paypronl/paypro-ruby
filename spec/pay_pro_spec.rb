# frozen_string_literal: true

RSpec.describe PayPro do
  it 'has a version number' do
    expect(PayPro::VERSION).to be('0.1.0')
  end

  describe '.config' do
    subject(:config) { described_class.config }

    it { is_expected.to be_a(PayPro::Config) }
  end

  describe '.configure' do
    let(:api_key) { '123456' }

    it 'sets the values of the config object' do
      described_class.configure do |config|
        config.api_key = api_key
        config.timeout = 10
      end

      expect(described_class.config).to have_attributes(
        api_key: api_key,
        timeout: 10
      )
    end
  end

  describe '.api_key=' do
    let(:api_key) { '123456' }

    it 'sets the api_key' do
      described_class.api_key = api_key
      expect(described_class.config.api_key).to eql(api_key)
    end
  end

  describe '.with_api_key' do
    let(:api_key) { '123456' }

    it 'sets the api_key for the duration of the block' do
      described_class.with_api_key(api_key) do
        expect(described_class.config.api_key).to eql(api_key)
      end
    end

    it 'resets the api_key to the original value after the block', :aggregate_failures do
      original_api_key = described_class.config.api_key

      described_class.with_api_key(api_key) do
        expect(described_class.config.api_key).to eql(api_key)
      end

      expect(described_class.config.api_key).to eql(original_api_key)
    end
  end
end
