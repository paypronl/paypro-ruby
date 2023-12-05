# frozen_string_literal: true

RSpec.describe PayPro::Util do
  describe '.entity_class' do
    subject { described_class.entity_class(string) }

    context 'when string is nil' do
      let(:string) { nil }

      it { is_expected.to be(PayPro::Entity) }
    end

    context 'when entity class can be found' do
      let(:string) { 'payment' }

      it { is_expected.to be(PayPro::Payment) }
    end

    context 'when entity class cannot be found' do
      let(:string) { 'unknown' }

      it { is_expected.to be(PayPro::Entity) }
    end
  end

  describe '.normalize_api_attributes' do
    subject(:normalized_attributes) { described_class.normalize_api_attributes(attributes) }

    let(:attributes) do
      {
        'id' => 'PPK002A23LV3CG',
        'type' => 'payment',
        'amount' => 500,
        '_links' => {
          'self' => 'https://api.paypro.test/payment'
        }
      }
    end

    it 'removes the type field' do
      expect(normalized_attributes.key?('type')).to be(false)
    end

    it 'removes the _links field' do
      expect(normalized_attributes.key?('_links')).to be(false)
    end

    it 'adds the links field' do
      expect(normalized_attributes['links']).to eql(attributes['_links'])
    end

    it 'does not edit the original' do
      expect(normalized_attributes).not_to eql(attributes)
    end
  end

  describe '.to_entity' do
    subject(:entity) { described_class.to_entity(data, params: params) }

    let(:params) { {} }

    context 'when data is a Hash' do
      context 'when type is not a list' do
        let(:data) do
          {
            'id' => 'PPK002A23LV3CG',
            'type' => 'payment',
            'amount' => 5000,
            'currency' => 'EUR',
            'description' => 'Test Payment'
          }
        end

        it { is_expected.to be_a(PayPro::Payment) }

        it 'has the correct attributes' do
          expect(entity).to have_attributes(
            id: 'PPK002A23LV3CG',
            amount: 5000,
            currency: 'EUR',
            description: 'Test Payment'
          )
        end
      end

      context 'when type is list' do
        let(:data) do
          {
            'type' => 'list',
            'count' => 0,
            'data' => []
          }
        end

        let(:params) { { 'limit' => 5 } }

        it { is_expected.to be_a(PayPro::List) }

        it 'has the correct attributes' do
          expect(entity).to have_attributes(
            count: 0,
            data: []
          )
        end

        it 'sets the filters correctly' do
          expect(entity.filters).to eql('limit' => 5)
        end
      end

      context 'without a type key' do
        let(:data) do
          {
            'custom' => 'Test',
            'payment' => {
              'id' => 'PPK002A23LV3CG',
              'type' => 'payment',
              'amount' => 5000,
              'currency' => 'EUR',
              'description' => 'Test Payment'
            }
          }
        end

        it { is_expected.to be_a(Hash) }

        it 'has the correct attributes' do
          expect(entity).to match(
            'custom' => 'Test',
            'payment' => be_a(PayPro::Payment).and(
              an_object_having_attributes(
                id: 'PPK002A23LV3CG',
                amount: 5000,
                currency: 'EUR',
                description: 'Test Payment'
              )
            )
          )
        end
      end
    end

    context 'when data is an Array' do
      let(:data) do
        [
          'Test',
          500,
          {
            'id' => 'PPK002A23LV3CG',
            'type' => 'payment',
            'amount' => 5000,
            'currency' => 'EUR',
            'description' => 'Test Payment'
          }
        ]
      end

      it { is_expected.to be_an(Array) }

      it 'has the correct elements' do
        expect(entity).to contain_exactly(
          'Test',
          500,
          be_a(PayPro::Payment).and(
            an_object_having_attributes(
              id: 'PPK002A23LV3CG',
              amount: 5000,
              currency: 'EUR',
              description: 'Test Payment'
            )
          )
        )
      end
    end

    context 'when data is not a Hash or Array' do
      let(:data) { 'Test String' }

      it { is_expected.to eql(data) }
    end
  end
end
