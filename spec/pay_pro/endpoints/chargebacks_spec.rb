# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::Chargebacks do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/chargebacks' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/chargebacks/list.json')
      )
    end

    it 'does the correct request' do
      list
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a List' do
      list
      expect(list).to be_a(PayPro::List)
    end

    it 'has chargebacks' do
      list
      expect(list.data[0]).to be_a(PayPro::Chargeback)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/chargebacks' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'PCV4U1P3UZTQPU' }
    let(:url) { "https://api.paypro.nl/chargebacks/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/chargebacks/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Chargeback' do
      expect(get).to be_a(PayPro::Chargeback)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        reason: 'MD06'
      )
    end

    context 'with options' do
      subject(:list) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/chargebacks/#{id}" }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end
end
