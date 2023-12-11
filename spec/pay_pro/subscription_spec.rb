# frozen_string_literal: true

RSpec.describe PayPro::Subscription do
  describe '.list' do
    subject(:list) { described_class.list }

    let(:url) { 'https://api.paypro.nl/subscriptions' }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/subscriptions/list.json')
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

    it 'has subscriptions' do
      list
      expect(list.data[0]).to be_a(described_class)
    end
  end

  describe '.get' do
    subject(:get) { described_class.get(id) }

    let(:id) { 'PS8PTGUPZTSLBP' }
    let(:url) { "https://api.paypro.nl/subscriptions/#{id}" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/subscriptions/get.json')
      )
    end

    it 'does the correct request' do
      get
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a Subscription' do
      expect(get).to be_a(described_class)
    end

    it 'has the correct attributes' do
      expect(get).to have_attributes(
        id: id,
        description: 'Unlimited Subscription',
        period: {
          'amount' => 2500,
          'interval' => 'month',
          'multiplier' => 1,
          'vat' => 21.0
        }
      )
    end
  end

  describe '#create' do
    subject(:create) { described_class.create(description: 'Unlimted Subscription') }

    let(:url) { 'https://api.paypro.nl/subscriptions' }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/subscriptions/get.json'),
        status: 201
      )
    end

    it 'does the correct request' do
      create
      expect(a_request(:post, url).with(body: { description: 'Unlimted Subscription' }.to_json)).to have_been_made
    end

    it 'returns a Subscription' do
      expect(create).to be_a(described_class)
    end
  end

  describe '#update' do
    subject(:update) { customer.update(description: 'Limited Subscription') }

    let(:customer) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/subscriptions/get.json')) }
    let(:id) { 'PS8PTGUPZTSLBP' }
    let(:url) { "https://api.paypro.nl/subscriptions/#{id}" }

    before do
      stub_request(:patch, url).and_return(
        body: File.read('spec/fixtures/subscriptions/get.json')
      )
    end

    it 'does the correct request' do
      update
      expect(a_request(:patch, url).with(body: { description: 'Limited Subscription' }.to_json)).to have_been_made
    end

    it 'returns a Subscription' do
      expect(update).to be_a(described_class)
    end
  end

  describe '#cancel' do
    subject(:cancel) { subscription.cancel }

    let(:subscription) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/subscriptions/get.json')) }
    let(:url) { "https://api.paypro.nl/subscriptions/#{subscription.id}" }

    before do
      stub_request(:delete, url).and_return(
        body: File.read('spec/fixtures/subscriptions/get.json')
      )
    end

    it 'does the correct request' do
      cancel
      expect(a_request(:delete, url)).to have_been_made
    end

    it 'returns a Subscription' do
      expect(cancel).to be_a(described_class)
    end
  end

  describe '#pause' do
    subject(:pause) { subscription.pause }

    let(:subscription) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/subscriptions/get.json')) }
    let(:url) { "https://api.paypro.nl/subscriptions/#{subscription.id}/pause" }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/subscriptions/get.json')
      )
    end

    it 'does the correct request' do
      pause
      expect(a_request(:post, url)).to have_been_made
    end

    it 'returns a Subscription' do
      expect(pause).to be_a(described_class)
    end
  end

  describe '#resume' do
    subject(:resume) { subscription.resume }

    let(:subscription) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/subscriptions/get.json')) }
    let(:url) { "https://api.paypro.nl/subscriptions/#{subscription.id}/resume" }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/subscriptions/get.json')
      )
    end

    it 'does the correct request' do
      resume
      expect(a_request(:post, url)).to have_been_made
    end

    it 'returns a Subscription' do
      expect(resume).to be_a(described_class)
    end
  end

  describe '#subscription_periods' do
    subject(:subscription_periods) { subscription.subscription_periods }

    let(:subscription) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/subscriptions/get.json')) }
    let(:url) { "https://api.paypro.nl/subscriptions/#{subscription.id}/subscription_periods" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/subscriptions/subscription_periods.json')
      )
    end

    it 'does the correct request' do
      subscription_periods
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a List' do
      subscription_periods
      expect(subscription_periods).to be_a(PayPro::List)
    end

    it 'has subscription periods' do
      subscription_periods
      expect(subscription_periods.data[0]).to be_a(PayPro::SubscriptionPeriod)
    end
  end

  describe '#create_subscription_period' do
    subject(:create_subscription_period) { subscription.create_subscription_period(amount: 5000) }

    let(:subscription) { described_class.create_from_data(data) }
    let(:data) { JSON.parse(File.read('spec/fixtures/subscriptions/get.json')) }
    let(:url) { "https://api.paypro.nl/subscriptions/#{subscription.id}/subscription_periods" }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/subscription_periods/get.json'),
        status: 201
      )
    end

    it 'does the correct request' do
      create_subscription_period
      expect(a_request(:post, url).with(body: { amount: 5000 }.to_json)).to have_been_made
    end

    it 'returns a Subscription Period' do
      expect(create_subscription_period).to be_a(PayPro::SubscriptionPeriod)
    end
  end
end
