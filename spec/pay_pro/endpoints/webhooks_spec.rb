# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::Webhooks do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/webhooks' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/webhooks/list.json')
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

    it 'has webhooks' do
      list
      expect(list.data[0]).to be_a(PayPro::Webhook)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/webhooks' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'WH43CVU3A1TD6Z' }
    let(:url) { "https://api.paypro.nl/webhooks/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/webhooks/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Webhook' do
      expect(get).to be_a(PayPro::Webhook)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        name: 'Test Webhook',
        url: 'https://example.org/paypro/webhook'
      )
    end

    context 'with options' do
      subject(:get) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/webhooks/#{id}" }

      it 'does the correct request' do
        get
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#create' do
    subject(:create) { endpoint.create({ active: true }) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/webhooks' }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/webhooks/get.json'),
        status: 201
      )
    end

    it 'does the correct request' do
      create
      expect(a_request(:post, url).with(body: { active: true }.to_json)).to have_been_made
    end

    it 'returns a Webhook' do
      expect(create).to be_a(PayPro::Webhook)
    end

    context 'with options' do
      subject(:create) { endpoint.create({ active: true }, api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/webhooks' }

      it 'does the correct request' do
        create
        expect(a_request(:post, url).with(body: { active: true }.to_json)).to have_been_made
      end
    end
  end
end
