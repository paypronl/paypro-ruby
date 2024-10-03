# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::Payments do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/payments' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/payments/list.json')
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

    it 'has payments' do
      list
      expect(list.data[0]).to be_a(PayPro::Payment)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/payments' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'PPSKN6FAN8KNE1' }
    let(:url) { "https://api.paypro.nl/payments/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/payments/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Payment' do
      expect(get).to be_a(PayPro::Payment)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        description: 'Unlimited Subscription',
        amount: 5000
      )
    end

    context 'with options' do
      subject(:get) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/payments/#{id}" }

      it 'does the correct request' do
        get
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#create' do
    subject(:create) { endpoint.create({ amount: 4500 }) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/payments' }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/payments/get.json'),
        status: 201
      )
    end

    it 'does the correct request' do
      create
      expect(a_request(:post, url).with(body: { amount: 4500 }.to_json)).to have_been_made
    end

    it 'returns a Payment' do
      expect(create).to be_a(PayPro::Payment)
    end

    context 'with options' do
      subject(:create) { endpoint.create({ amount: 4500 }, api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/payments' }

      it 'does the correct request' do
        create
        expect(a_request(:post, url).with(body: { amount: 4500 }.to_json)).to have_been_made
      end
    end
  end
end
