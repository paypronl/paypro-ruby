# frozen_string_literal: true

RSpec.describe PayPro::Endpoints::InstallmentPlanPeriods do
  describe '#get' do
    subject(:get) { endpoint.get(id) }

    let(:endpoint) { described_class.new(api_client: default_api_client) }

    let(:id) { 'IPD344S1PDY8XX' }
    let(:url) { "https://api.paypro.nl/installment_plan_periods/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/installment_plan_periods/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Payment' do
      expect(get).to be_a(PayPro::InstallmentPlanPeriod)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        period_number: 1,
        amount: 1500
      )
    end

    context 'with options' do
      subject(:get) { endpoint.get(id, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/installment_plan_periods/#{id}" }

      it 'does the correct request' do
        get
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end
end
