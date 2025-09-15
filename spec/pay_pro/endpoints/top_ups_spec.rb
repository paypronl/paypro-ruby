# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::TopUps do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/top_ups' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/top_ups/list.json')
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

    it 'has top_ups' do
      list
      expect(list.data[0]).to be_a(PayPro::TopUp)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/top_ups' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'TUMKR465ZG6QDU' }
    let(:url) { "https://api.paypro.nl/top_ups/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/top_ups/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a TopUp' do
      expect(get).to be_a(PayPro::TopUp)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        amount: 123_00
      )
    end

    context 'with options' do
      subject(:list) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/top_ups/#{id}" }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#create' do
    subject(:create) { endpoint.create({ amount: 123_00, currency: 'EUR' }) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/top_ups' }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/top_ups/get.json'),
        status: 201
      )
    end

    it 'does the correct request' do
      create

      expect(
        a_request(:post, url).with(
          body: { amount: 123_00, currency: 'EUR' }.to_json
        )
      ).to have_been_made
    end

    it 'returns a Mandate' do
      expect(create).to be_a(PayPro::TopUp)
    end

    context 'with options' do
      subject(:create) do
        endpoint.create(
          { amount: 123_00, currency: 'EUR' },
          api_url: 'https://api-test.paypro.nl'
        )
      end

      let(:url) { 'https://api-test.paypro.nl/top_ups' }

      it 'does the correct request' do
        create

        expect(
          a_request(:post, url).with(
            body: { amount: 123_00, currency: 'EUR' }.to_json
          )
        ).to have_been_made
      end
    end
  end
end
