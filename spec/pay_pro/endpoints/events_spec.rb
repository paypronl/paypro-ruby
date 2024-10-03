# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::Events do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/events' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/events/list.json')
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

    it 'has events' do
      list
      expect(list.data[0]).to be_a(PayPro::Event)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/events' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'EVYK7KCFJAXA23UKSG' }
    let(:url) { "https://api.paypro.nl/events/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/events/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns an Event' do
      expect(get).to be_a(PayPro::Event)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        event_type: 'payment.created',
        payload: a_kind_of(PayPro::Payment)
      )
    end

    context 'with options' do
      subject(:get) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/events/#{id}" }

      it 'does the correct request' do
        get
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end
end
