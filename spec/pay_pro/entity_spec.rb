# frozen_string_literal: true

RSpec.describe PayPro::Entity do
  describe '.create_from_data' do
    subject(:entity) { described_class.create_from_data(data, api_client: default_api_client) }

    let(:data) do
      {
        'id' => 'PPXNQT8MXCA2UT',
        'type' => 'payment',
        'amount' => 5000,
        'description' => 'Test Payment',
        '_links' => {
          'self' => 'https://api.paypro.nl/payments/PPXNQT8MXCA2UT'
        }
      }
    end

    it 'creates a PayPro::Entity' do
      expect(entity).to be_a(described_class)
    end

    it 'has the correct attributes' do
      expect(entity).to have_attributes(
        id: 'PPXNQT8MXCA2UT',
        amount: 5000,
        description: 'Test Payment',
        links: {
          'self' => 'https://api.paypro.nl/payments/PPXNQT8MXCA2UT'
        }
      )
    end

    it 'creates the accessors' do
      entity.amount = 4500
      expect(entity.amount).to be(4500)
    end

    it 'does not have the stripped attributes' do
      expect(entity.methods).not_to include(:type, :_links)
    end

    context 'with unknown attributes' do
      let(:data) { { 'unknown' => 'abc' } }

      it 'creates a PayPro::Entity' do
        expect(entity).to be_a(described_class)
      end

      it 'has the correct attributes' do
        expect(entity).to have_attributes(
          unknown: 'abc'
        )
      end

      it 'creates the accessors' do
        entity.unknown = 4500
        expect(entity.unknown).to be(4500)
      end
    end
  end
end
