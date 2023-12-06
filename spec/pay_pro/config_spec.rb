# frozen_string_literal: true

RSpec.describe PayPro::Config do
  describe 'initialize' do
    subject(:config) { described_class.new }

    it 'sets the default values' do
      expect(config).to have_attributes(
        api_key: nil,
        api_url: 'https://api.paypro.nl',
        ca_bundle_path: a_string_including('/data/cacert.pem'),
        timeout: 30,
        verify_ssl: true
      )
    end
  end

  describe '#merge' do
    subject(:new_config) { config.merge(hash) }

    let(:config) { described_class.new }

    context 'when hash is empty' do
      let(:hash) { {} }

      it 'returns the default values' do
        expect(new_config).to have_attributes(
          api_key: nil,
          api_url: 'https://api.paypro.nl',
          ca_bundle_path: a_string_including('/data/cacert.pem'),
          timeout: 30,
          verify_ssl: true
        )
      end
    end

    context 'when hash is not empty' do
      let(:hash) { { api_key: '1234', api_url: 'https://test.paypro.nl', ca_bundle_path: '/ssl/cert.pem' } }

      it 'returns the merged values' do
        expect(new_config).to have_attributes(
          api_key: '1234',
          api_url: 'https://test.paypro.nl',
          ca_bundle_path: '/ssl/cert.pem',
          timeout: 30,
          verify_ssl: true
        )
      end
    end
  end
end
