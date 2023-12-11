# frozen_string_literal: true

RSpec.describe PayPro::Chargeback do
  describe '.list' do
    subject(:list) { described_class.list }

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
      expect(list.data[0]).to be_a(described_class)
    end
  end

  describe '.get' do
    subject(:get) { described_class.get(id) }

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
      expect(get).to be_a(described_class)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        reason: 'MD06'
      )
    end
  end
end
