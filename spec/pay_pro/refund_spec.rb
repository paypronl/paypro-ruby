# frozen_string_literal: true

RSpec.describe PayPro::Refund do
  describe '#cancel' do
    subject(:cancel) { refund.cancel }

    let(:refund) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/refunds/get.json')) }
    let(:url) { "https://api.paypro.nl/refunds/#{refund.id}" }

    before do
      stub_request(:delete, url).and_return(
        body: File.read('spec/fixtures/refunds/get.json')
      )
    end

    it 'does the correct request' do
      cancel
      expect(a_request(:delete, url)).to have_been_made
    end

    it 'returns a Refund' do
      expect(cancel).to be_a(described_class)
    end

    context 'with options' do
      subject(:cancel) { refund.cancel(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/refunds/#{refund.id}" }

      it 'does the correct request' do
        cancel
        expect(a_request(:delete, url)).to have_been_made
      end
    end
  end
end
