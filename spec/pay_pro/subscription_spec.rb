# frozen_string_literal: true

RSpec.describe PayPro::Subscription do
  describe '#update' do
    subject(:update) { subscription.update({ description: 'Limited Subscription' }) }

    let(:subscription) { described_class.create_from_data(data, api_client: default_api_client) }
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

    context 'with options' do
      subject(:update) do
        subscription.update({ description: 'Limited Subscription' }, api_url: 'https://api-test.paypro.nl')
      end

      let(:url) { "https://api-test.paypro.nl/subscriptions/#{id}" }

      it 'does the correct request' do
        update
        expect(a_request(:patch, url).with(body: { description: 'Limited Subscription' }.to_json)).to have_been_made
      end
    end
  end

  describe '#cancel' do
    subject(:cancel) { subscription.cancel }

    let(:subscription) { described_class.create_from_data(data, api_client: default_api_client) }
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

    context 'with options' do
      subject(:cancel) { subscription.cancel(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/subscriptions/#{subscription.id}" }

      it 'does the correct request' do
        cancel
        expect(a_request(:delete, url)).to have_been_made
      end
    end
  end

  describe '#pause' do
    subject(:pause) { subscription.pause }

    let(:subscription) { described_class.create_from_data(data, api_client: default_api_client) }
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

    context 'with options' do
      subject(:pause) { subscription.pause(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/subscriptions/#{subscription.id}/pause" }

      it 'does the correct request' do
        pause
        expect(a_request(:post, url)).to have_been_made
      end
    end
  end

  describe '#resume' do
    subject(:resume) { subscription.resume }

    let(:subscription) { described_class.create_from_data(data, api_client: default_api_client) }
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

    context 'with options' do
      subject(:resume) { subscription.resume(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/subscriptions/#{subscription.id}/resume" }

      it 'does the correct request' do
        resume
        expect(a_request(:post, url)).to have_been_made
      end
    end
  end

  describe '#subscription_periods' do
    subject(:subscription_periods) { subscription.subscription_periods }

    let(:subscription) { described_class.create_from_data(data, api_client: default_api_client) }
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

    context 'with options' do
      subject(:subscription_periods) { subscription.subscription_periods(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/subscriptions/#{subscription.id}/subscription_periods" }

      it 'does the correct request' do
        subscription_periods
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#create_subscription_period' do
    subject(:create_subscription_period) { subscription.create_subscription_period({ amount: 5000 }) }

    let(:subscription) { described_class.create_from_data(data, api_client: default_api_client) }
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

    context 'with options' do
      subject(:create_subscription_period) do
        subscription.create_subscription_period({ amount: 5000 }, api_url: 'https://api-test.paypro.nl')
      end

      let(:url) { "https://api-test.paypro.nl/subscriptions/#{subscription.id}/subscription_periods" }

      it 'does the correct request' do
        create_subscription_period
        expect(a_request(:post, url).with(body: { amount: 5000 }.to_json)).to have_been_made
      end
    end
  end
end
