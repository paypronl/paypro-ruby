# frozen_string_literal: true

RSpec.describe PayPro::Refund do
  describe '.list' do
    subject(:list) { described_class.list }

    let(:url) { 'https://api.paypro.nl/refunds' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/refunds/list.json')
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

    it 'has refunds' do
      list
      expect(list.data[0]).to be_a(described_class)
    end
  end

  describe '.get' do
    subject(:get) { described_class.get(id) }

    let(:id) { 'PRNAUYTZ727UED' }
    let(:url) { "https://api.paypro.nl/refunds/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/refunds/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Refund' do
      expect(get).to be_a(described_class)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        description: 'Test Payment',
        refunded_at: nil
      )
    end
  end

  describe '#cancel' do
    subject(:cancel) { refund.cancel }

    let(:refund) { described_class.create_from_data(data) }
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
  end
end
