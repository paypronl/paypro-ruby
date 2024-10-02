# frozen_string_literal: true

RSpec.describe PayPro::InstallmentPlanPeriod do
  describe '.get' do
    subject(:get) { described_class.get(id) }

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
      expect(get).to be_a(described_class)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        period_number: 1,
        amount: 1500
      )
    end
  end
end
