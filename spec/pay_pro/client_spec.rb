# frozen_string_literal: true

RSpec.describe PayPro::Client do
  describe 'initialize' do
    subject(:client) { described_class.new(config) }

    let(:config) { 'pp_4321' }

    it 'has the correct config' do
      expect(client.config.api_key).to eql('pp_4321')
    end

    it 'sets the endpoints correctly', :aggregate_failures do
      expect(client.chargebacks).to be_a(PayPro::Endpoints::Chargebacks)
      expect(client.customers).to be_a(PayPro::Endpoints::Customers)
      expect(client.events).to be_a(PayPro::Endpoints::Events)
      expect(client.mandates).to be_a(PayPro::Endpoints::Mandates)
      expect(client.payments).to be_a(PayPro::Endpoints::Payments)
      expect(client.pay_methods).to be_a(PayPro::Endpoints::PayMethods)
      expect(client.refunds).to be_a(PayPro::Endpoints::Refunds)
      expect(client.subscription_periods).to be_a(PayPro::Endpoints::SubscriptionPeriods)
      expect(client.subscriptions).to be_a(PayPro::Endpoints::Subscriptions)
      expect(client.webhooks).to be_a(PayPro::Endpoints::Webhooks)
    end

    context 'when config is a hash' do
      let(:config) { { api_key: 'pp_4321' } }

      it 'has the correct config' do
        expect(client.config.api_key).to eql('pp_4321')
      end
    end

    context 'when config is a PayPro::Config' do
      let(:config) { PayPro::Config.new.merge(api_key: 'pp_4321') }

      it 'has the correct config' do
        expect(client.config.api_key).to eql('pp_4321')
      end
    end

    context 'when config is an invalid argument' do
      let(:config) { 1234 }

      it 'raises an error' do
        expect { client }.to raise_error(
          PayPro::ConfigurationError,
          'Invalid argument: 1234'
        )
      end
    end

    context 'when API key not supplied' do
      let(:config) { PayPro::Config.new }

      it 'raises an error' do
        expect { client }.to raise_error(
          PayPro::ConfigurationError,
          'API key not set or given. ' \
          'Make sure to pass an API key or set a default with "PayPro.api_key=". ' \
          'You can find your API key in the PayPro dashboard at "https://app.paypro.nl/developers/api-keys".'
        )
      end
    end
  end
end
