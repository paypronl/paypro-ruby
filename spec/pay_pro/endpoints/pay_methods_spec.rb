# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::PayMethods do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/pay_methods' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/pay_methods/list.json')
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

    it 'has pay methods' do
      list
      expect(list.data[0]).to be_a(PayPro::PayMethod)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/pay_methods' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end
end
