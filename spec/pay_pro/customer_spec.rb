# frozen_string_literal: true

RSpec.describe PayPro::Customer do
  describe '.list' do
    subject(:list) { described_class.list }

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

    it 'has customers' do
      list
      expect(list.data[0]).to be_a(described_class)
    end
  end

  describe '.get' do
    subject(:get) { described_class.get(id) }

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
      expect(get).to be_a(described_class)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        city: 'Amsterdam',
        address: 'Gangpad 12'
      )
    end
  end

  describe '#create' do
    subject(:create) { described_class.create(address: 'Gangpad 12') }

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
      expect(create).to be_a(described_class)
    end
  end

  describe '#update' do
    subject(:update) { customer.update(address: 'Gangpad 11') }

    let(:customer) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/customers/get.json')) }
    let(:id) { 'CU10TV703T84E0' }
    let(:url) { "https://api.paypro.nl/customers/#{id}" }

    before do
      stub_request(:patch, url).and_return(
        body: File.read('spec/fixtures/customers/get.json')
      )
    end

    it 'does the correct request' do
      update
      expect(a_request(:patch, url).with(body: { address: 'Gangpad 11' }.to_json)).to have_been_made
    end

    it 'returns a Customer' do
      expect(update).to be_a(described_class)
    end
  end

  describe '#delete' do
    subject(:delete) { customer.delete }

    let(:customer) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/customers/get.json')) }
    let(:url) { "https://api.paypro.nl/customers/#{customer.id}" }

    before do
      stub_request(:delete, url).and_return(
        body: File.read('spec/fixtures/customers/get.json')
      )
    end

    it 'does the correct request' do
      delete
      expect(a_request(:delete, url)).to have_been_made
    end

    it 'returns a Customer' do
      expect(delete).to be_a(described_class)
    end
  end
end
