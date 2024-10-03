# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::Customers do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/customers' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/customers/list.json')
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
      expect(list.data[0]).to be_a(PayPro::Customer)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/customers' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'CU10TV703T84E0' }
    let(:url) { "https://api.paypro.nl/customers/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/customers/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Customer' do
      expect(get).to be_a(PayPro::Customer)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        city: 'Amsterdam',
        address: 'Gangpad 12'
      )
    end

    context 'with options' do
      subject(:list) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/customers/#{id}" }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#create' do
    subject(:create) { endpoint.create({ address: 'Gangpad 12' }) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/customers' }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/customers/get.json'),
        status: 201
      )
    end

    it 'does the correct request' do
      create
      expect(a_request(:post, url).with(body: { address: 'Gangpad 12' }.to_json)).to have_been_made
    end

    it 'returns a Customer' do
      expect(create).to be_a(PayPro::Customer)
    end

    context 'with options' do
      subject(:create) { endpoint.create({ address: 'Gangpad 12' }, api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/customers' }

      it 'does the correct request' do
        create
        expect(a_request(:post, url).with(body: { address: 'Gangpad 12' }.to_json)).to have_been_made
      end
    end
  end
end
