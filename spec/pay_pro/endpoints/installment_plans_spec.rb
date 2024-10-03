# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::InstallmentPlans do
  describe '#list' do
    subject(:list) { endpoint.list }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/installment_plans' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/installment_plans/list.json')
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

    it 'has installment plans' do
      list
      expect(list.data[0]).to be_a(PayPro::InstallmentPlan)
    end

    context 'with options' do
      subject(:list) { endpoint.list(api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/installment_plans' }

      it 'does the correct request' do
        list
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'PIPLEMXPQMHB544' }
    let(:url) { "https://api.paypro.nl/installment_plans/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/installment_plans/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a InstallmentPlan' do
      expect(get).to be_a(PayPro::InstallmentPlan)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        description: 'Test installment plan',
        period: {
          'amount' => 1000,
          'interval' => 'month',
          'multiplier' => 1,
          'vat' => 21.0
        }
      )
    end

    context 'with options' do
      subject(:get) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/installment_plans/#{id}" }

      it 'does the correct request' do
        get
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#create' do
    subject(:create) { endpoint.create({ description: 'Test installment plan' }) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:url) { 'https://api.paypro.nl/installment_plans' }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/installment_plans/get.json'),
        status: 201
      )
    end

    it 'does the correct request' do
      create
      expect(a_request(:post, url).with(body: { description: 'Test installment plan' }.to_json)).to have_been_made
    end

    it 'returns a InstallmentPlan' do
      expect(create).to be_a(PayPro::InstallmentPlan)
    end

    context 'with options' do
      subject(:create) { endpoint.create({ description: 'Test installment plan' }, api_url: 'https://api-test.paypro.nl') }

      let(:url) { 'https://api-test.paypro.nl/installment_plans' }

      it 'does the correct request' do
        create
        expect(a_request(:post, url).with(body: { description: 'Test installment plan' }.to_json)).to have_been_made
      end
    end
  end
end
