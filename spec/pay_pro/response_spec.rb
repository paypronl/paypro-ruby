# frozen_string_literal: true

RSpec.describe PayPro::Response do
  describe '.from_response' do
    subject(:paypro_response) { described_class.from_response(response) }

    let(:response) do
      instance_double(
        Faraday::Response,
        body: '{"test": 123}',
        status: 200,
        headers: {
          'x-request-id' => '2de44ce1-2ace-4118-922e-e53ab33f6fc7'
        }
      )
    end

    it { is_expected.to be_a(described_class) }

    it 'has the correct attributes' do
      expect(paypro_response).to have_attributes(
        data: { 'test' => 123 },
        raw_body: '{"test": 123}',
        status: 200,
        request_id: '2de44ce1-2ace-4118-922e-e53ab33f6fc7'
      )
    end
  end
end
