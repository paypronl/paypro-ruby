# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::Mandates do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

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
      expect(list.data[0]).to be_a(PayPro::Mandate)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/mandates' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

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
      expect(get).to be_a(PayPro::Mandate)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        customer: 'CUWSWVVPTL94VX',
        pay_method: 'direct-debit'
      )
    end

    context 'with options' do
      subject(:get) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/mandates/#{id}" }

      it 'does the correct request' do
        get
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#create' do
    subject(:create) { endpoint.create({ customer: 'CUWSWVVPTL94VX', pay_method: 'direct-debit' }) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

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
      expect(create).to be_a(PayPro::Mandate)
    end

    context 'with options' do
      subject(:create) do
        endpoint.create(
          { customer: 'CUWSWVVPTL94VX', pay_method: 'direct-debit' },
          api_url: 'https://api-test.paypro.nl'
        )
      end

      let(:url) { 'https://api-test.paypro.nl/mandates' }

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
    end
  end
end
