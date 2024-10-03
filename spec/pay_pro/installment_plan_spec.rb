# frozen_string_literal: true

RSpec.describe PayPro::InstallmentPlan do
  describe '#update' do
    subject(:update) { installment_plan.update({ description: 'Test installment plan' }) }

    let(:installment_plan) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/installment_plans/get.json')) }
    let(:id) { 'PIPLEMXPQMHB544' }
    let(:url) { "https://api.paypro.nl/installment_plans/#{id}" }

    before do
      stub_request(:patch, url).and_return(
        body: File.read('spec/fixtures/installment_plans/get.json')
      )
    end

    it 'does the correct request' do
      update
      expect(a_request(:patch, url).with(body: { description: 'Test installment plan' }.to_json)).to have_been_made
    end

    it 'returns a InstallmentPlan' do
      expect(update).to be_a(described_class)
    end

    context 'with options' do
      subject(:update) do
        installment_plan.update({ description: 'Test installment plan' }, api_url: 'https://api-test.paypro.nl')
      end

      let(:url) { "https://api-test.paypro.nl/installment_plans/#{id}" }

      it 'does the correct request' do
        update
        expect(a_request(:patch, url).with(body: { description: 'Test installment plan' }.to_json)).to have_been_made
      end
    end
  end

  describe '#cancel' do
    subject(:cancel) { installment_plan.cancel }

    let(:installment_plan) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/installment_plans/get.json')) }
    let(:url) { "https://api.paypro.nl/installment_plans/#{installment_plan.id}" }

    before do
      stub_request(:delete, url).and_return(
        body: File.read('spec/fixtures/installment_plans/get.json')
      )
    end

    it 'does the correct request' do
      cancel
      expect(a_request(:delete, url)).to have_been_made
    end

    it 'returns a InstallmentPlan' do
      expect(cancel).to be_a(described_class)
    end

    context 'with options' do
      subject(:cancel) { installment_plan.cancel(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/installment_plans/#{installment_plan.id}" }

      it 'does the correct request' do
        cancel
        expect(a_request(:delete, url)).to have_been_made
      end
    end
  end

  describe '#pause' do
    subject(:pause) { installment_plan.pause }

    let(:installment_plan) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/installment_plans/get.json')) }
    let(:url) { "https://api.paypro.nl/installment_plans/#{installment_plan.id}/pause" }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/installment_plans/get.json')
      )
    end

    it 'does the correct request' do
      pause
      expect(a_request(:post, url)).to have_been_made
    end

    it 'returns a InstallmentPlan' do
      expect(pause).to be_a(described_class)
    end

    context 'with options' do
      subject(:pause) { installment_plan.pause(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/installment_plans/#{installment_plan.id}/pause" }

      it 'does the correct request' do
        pause
        expect(a_request(:post, url)).to have_been_made
      end
    end
  end

  describe '#resume' do
    subject(:resume) { installment_plan.resume }

    let(:installment_plan) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/installment_plans/get.json')) }
    let(:url) { "https://api.paypro.nl/installment_plans/#{installment_plan.id}/resume" }

    before do
      stub_request(:post, url).and_return(
        body: File.read('spec/fixtures/installment_plans/get.json')
      )
    end

    it 'does the correct request' do
      resume
      expect(a_request(:post, url)).to have_been_made
    end

    it 'returns a InstallmentPlan' do
      expect(resume).to be_a(described_class)
    end

    context 'with options' do
      subject(:resume) { installment_plan.resume(api_url: 'https://api-test.paypro.nl') }

      let(:url) { "https://api-test.paypro.nl/installment_plans/#{installment_plan.id}/resume" }

      it 'does the correct request' do
        resume
        expect(a_request(:post, url)).to have_been_made
      end
    end
  end

  describe '#installment_plan_periods' do
    subject(:installment_plan_periods) { installment_plan.installment_plan_periods }

    let(:installment_plan) { described_class.create_from_data(data, api_client: default_api_client) }
    let(:data) { JSON.parse(File.read('spec/fixtures/installment_plans/get.json')) }
    let(:url) { "https://api.paypro.nl/installment_plans/#{installment_plan.id}/installment_plan_periods" }

    before do
      stub_request(:get, url).and_return(
        body: File.read('spec/fixtures/installment_plans/installment_plan_periods.json')
      )
    end

    it 'does the correct request' do
      installment_plan_periods
      expect(a_request(:get, url)).to have_been_made
    end

    it 'returns a List' do
      installment_plan_periods
      expect(installment_plan_periods).to be_a(PayPro::List)
    end

    it 'has installment plan periods' do
      installment_plan_periods
      expect(installment_plan_periods.data[0]).to be_a(PayPro::InstallmentPlanPeriod)
    end

    context 'with options' do
      subject(:installment_plan_periods) do
        installment_plan.installment_plan_periods(api_url: 'https://api-test.paypro.nl')
      end

      let(:url) { "https://api-test.paypro.nl/installment_plans/#{installment_plan.id}/installment_plan_periods" }

      it 'does the correct request' do
        installment_plan_periods
        expect(a_request(:get, url)).to have_been_made
      end
    end
  end
end
