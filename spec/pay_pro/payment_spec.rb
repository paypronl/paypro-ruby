# frozen_string_literal: true

RSpec.describe PayPro::Payment do
  describe '#cancel' do
    subject(:cancel) { payment.cancel }

    let(:payment) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/payments/get.json')) }
    let(:url) { "https://api.paypro.nl/payments/#{payment.id}" }

    before do
      stub_request(:delete, url).and_return(
        body: File.read('spec/fixtures/payments/get.json')
      )
    end

    it 'does the correct request' do
      cancel
      expect(a_request(:delete, url)).to have_been_made
    end

    it 'returns a Payment' do
      expect(cancel).to be_a(described_class)
    end

    context 'with options' do
      subject(:cancel) { payment.cancel(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/payments/#{payment.id}" }

      it 'does the correct request' do
        cancel
        expect(a_request(:delete, url)).to have_been_made
      end
    end
  end

  describe '#refund' do
    subject(:refund) { payment.refund({ amount: 2000 }) }

    let(:payment) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/payments/get.json')) }
    let(:url) { "https://api.paypro.nl/payments/#{payment.id}/refunds" }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/payments/refund.json')
      )
    end

    it 'does the correct request' do
      refund
      expect(a_request(:post, url).with(body: { amount: 2000 }.to_json)).to have_been_made
    end

    it 'returns a Refund' do
      expect(refund).to be_a(PayPro::Refund)
    end

    context 'with options' do
      subject(:refund) { payment.refund({ amount: 2000 }, api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/payments/#{payment.id}/refunds" }

      it 'does the correct request' do
        refund
        expect(a_request(:post, url).with(body: { amount: 2000 }.to_json)).to have_been_made
      end
    end
  end

  describe '#refunds' do
    subject(:refunds) { payment.refunds }

    let(:payment) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/payments/get.json')) }
    let(:url) { "https://api.paypro.nl/payments/#{payment.id}/refunds" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/payments/refunds.json')
      )
    end

    it 'does the correct request' do
      refunds
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a List' do
      refunds
      expect(refunds).to be_a(PayPro::List)
    end

    it 'has refunds' do
      refunds
      expect(refunds.data[0]).to be_a(PayPro::Refund)
    end

    context 'with options' do
      subject(:refunds) { payment.refunds(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/payments/#{payment.id}/refunds" }

      it 'does the correct request' do
        refunds
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end

  describe '#chargebacks' do
    subject(:chargebacks) { payment.chargebacks }

    let(:payment) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/payments/get.json')) }
    let(:url) { "https://api.paypro.nl/payments/#{payment.id}/chargebacks" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/payments/chargebacks.json')
      )
    end

    it 'does the correct request' do
      chargebacks
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a List' do
      chargebacks
      expect(chargebacks).to be_a(PayPro::List)
    end

    it 'has chargebacks' do
      chargebacks
      expect(chargebacks.data[0]).to be_a(PayPro::Chargeback)
    end

    context 'with options' do
      subject(:chargebacks) { payment.chargebacks(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/payments/#{payment.id}/chargebacks" }

      it 'does the correct request' do
        chargebacks
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end
end
