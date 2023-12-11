# frozen_string_literal: true

RSpec.describe PayPro::SubscriptionPeriod do
  describe '.list' do
    subject(:list) { described_class.list }

    let(:url) { 'https://api.paypro.nl/subscription_periods' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/subscription_periods/list.json')
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

    it 'has subscription_periods' do
      list
      expect(list.data[0]).to be_a(described_class)
    end
  end

  describe '.get' do
    subject(:get) { described_class.get(id) }

    let(:id) { 'SPCMTC4RJLPNWT' }
    let(:url) { "https://api.paypro.nl/subscription_periods/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/subscription_periods/get.json')
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
        amount: 5000
      )
    end
  end
end
