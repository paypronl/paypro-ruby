# frozen_string_literal: true

RSpec.describe PayPro::Mandate do
  describe '.list' do
    subject(:list) { described_class.list }

    let(:url) { 'https://api.paypro.nl/mandates' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/mandates/list.json')
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

    it 'has mandates' do
      list
      expect(list.data[0]).to be_a(described_class)
    end
  end

  describe '.get' do
    subject(:get) { described_class.get(id) }

    let(:id) { 'MDQVT0CGB8Z5JK' }
    let(:url) { "https://api.paypro.nl/mandates/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/mandates/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Mandate' do
      expect(get).to be_a(described_class)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        customer: 'CUWSWVVPTL94VX',
        pay_method: 'direct-debit'
      )
    end
  end

  describe '#create' do
    subject(:create) { described_class.create(customer: 'CUWSWVVPTL94VX', pay_method: 'direct-debit') }

    let(:url) { 'https://api.paypro.nl/mandates' }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/mandates/get.json'),
        status: 201
      )
    end

    it 'does the correct request' do
      create

      expect(
        a_request(:post, url).with(
          body: {
            customer: 'CUWSWVVPTL94VX',
            pay_method: 'direct-debit'
          }.to_json
        )
      ).to have_been_made
    end

    it 'returns a Mandate' do
      expect(create).to be_a(described_class)
    end
  end
end
