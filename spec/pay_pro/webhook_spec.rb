# frozen_string_literal: true

RSpec.describe PayPro::Webhook do
  describe '.list' do
    subject(:list) { described_class.list }

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
      expect(list.data[0]).to be_a(described_class)
    end
  end

  describe '.get' do
    subject(:get) { described_class.get(id) }

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
      expect(get).to be_a(described_class)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        name: 'Test Webhook',
        url: 'https://example.org/paypro/webhook'
      )
    end
  end

  describe '#create' do
    subject(:create) { described_class.create(active: true) }

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
      expect(create).to be_a(described_class)
    end
  end

  describe '#update' do
    subject(:update) { customer.update(active: false) }

    let(:customer) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/webhooks/get.json')) }
    let(:id) { 'WH43CVU3A1TD6Z' }
    let(:url) { "https://api.paypro.nl/webhooks/#{id}" }

    before do
      stub_request(:patch, url).and_return(
        body: File.read('spec/fixtures/webhooks/get.json')
      )
    end

    it 'does the correct request' do
      update
      expect(a_request(:patch, url).with(body: { active: false }.to_json)).to have_been_made
    end

    it 'returns a Webhook' do
      expect(update).to be_a(described_class)
    end
  end

  describe '#delete' do
    subject(:delete) { customer.delete }

    let(:customer) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/webhooks/get.json')) }
    let(:url) { "https://api.paypro.nl/webhooks/#{customer.id}" }

    before do
      stub_request(:delete, url).and_return(
        body: File.read('spec/fixtures/webhooks/get.json')
      )
    end

    it 'does the correct request' do
      delete
      expect(a_request(:delete, url)).to have_been_made
    end

    it 'returns a Webhook' do
      expect(delete).to be_a(described_class)
    end
  end

  describe '.create_event' do
    subject(:event) do
      described_class.create_event(
        payload: payload,
        timestamp: timestamp,
        secret: secret,
        signature: signature
      )
    end

    let(:payload) { File.read('spec/fixtures/events/get.json') }
    let(:secret) { '996QF2kLfVcmF8hzikZVfeB7GPH2RdP7' }
    let(:timestamp) { 1_702_298_964 }

    before { Timecop.freeze(Time.at(timestamp)) }

    after { Timecop.return }

    context 'when the signature is invalid' do
      let(:signature) { 'secret' }

      it 'raises an error' do
        expect { event }.to raise_error(PayPro::SignatureVerificationError, 'Signature does not match')
      end
    end

    context 'when the signature is valid' do
      let(:signature) { 'c3e62291042d23fb21c1a0881544125a667f0f9df90d81a91ca9ccc9e4b9f6ec' }

      it 'returns an Event object' do
        expect(event).to be_a(PayPro::Event)
      end
    end

    context 'when payload is invalid json' do
      let(:payload) { '' }
      let(:signature) { 'd83474e81c7758cc82ff6a4bf60e592a64ff8f54d1de82115acb9d1d1ec4793d' }

      it 'raises a JSON parser error' do
        expect { event }.to raise_error(JSON::ParserError)
      end
    end
  end
end
