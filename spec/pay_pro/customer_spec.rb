# frozen_string_literal: true

RSpec.describe PayPro::Customer do
  describe '#update' do
    subject(:update) { customer.update({ address: 'Gangpad 11' }) }

    let(:customer) { described_class.create_from_data(data, api_client: default_api_client) }
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

    context 'with options' do
      subject(:update) { customer.update({ address: 'Gangpad 11' }, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/customers/#{id}" }

      it 'does the correct request' do
        update
        expect(a_request(:patch, url).with(body: { address: 'Gangpad 11' }.to_json)).to have_been_made
      end
    end
  end

  describe '#delete' do
    subject(:delete) { customer.delete }

    let(:customer) { described_class.create_from_data(data, api_client: default_api_client) }
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

    context 'with options' do
      subject(:update) { customer.delete(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api.paypro.nl/customers/#{customer.id}" }

      it 'does the correct request' do
        delete
        expect(a_request(:delete, url)).to have_been_made
      end
    end
  end
end
