# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::Balances do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/balances' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/balances/list.json')
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

    it 'has balances' do
      list
      expect(list.data[0]).to be_a(PayPro::Balance)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/balances' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'PBA7HA516X604D' }
    let(:url) { "https://api.paypro.nl/balances/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/balances/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Balance' do
      expect(get).to be_a(PayPro::Balance)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        amount: 1000
      )
    end

    context 'with options' do
      subject(:list) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/balances/#{id}" }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end
end
