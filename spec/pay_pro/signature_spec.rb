# frozen_string_literal: true

RSpec.describe PayPro::Signature do
  describe 'initialize' do
    subject(:signature) do
      described_class.new(
        payload: payload,
        timestamp: timestamp,
        secret: secret
      )
    end

    let(:payload) { '' }
    let(:secret) { 'secret' }
    let(:timestamp) { Time.at(1_702_298_964) }

    it { is_expected.to be_a(described_class) }

    context 'when timestamp is not an instance of Time' do
      let(:timestamp) { 1_702_298_964 }

      it 'raises an ArgumentError' do
        expect { signature }.to raise_error(ArgumentError, 'timestamp must be an instance of Time')
      end
    end

    context 'when payload is not a String' do
      let(:payload) { nil }

      it 'raises an ArgumentError' do
        expect { signature }.to raise_error(ArgumentError, 'payload must be a String')
      end
    end

    context 'when secret is not a String' do
      let(:secret) { 123 }

      it 'raises an ArgumentError' do
        expect { signature }.to raise_error(ArgumentError, 'secret must be a String')
      end
    end

    context 'when tolerance is not an Integer' do
      subject(:signature) do
        described_class.new(
          payload: payload,
          timestamp: timestamp,
          secret: secret,
          tolerance: '123'
        )
      end

      it 'raises an ArgumentError' do
        expect { signature }.to raise_error(ArgumentError, 'tolerance must be an Integer')
      end
    end
  end

  describe '#generate_signature' do
    subject { signature.generate_signature }

    let(:signature) do
      described_class.new(
        payload: payload,
        timestamp: timestamp,
        secret: secret
      )
    end

    context 'with some values' do
      let(:payload) { '' }
      let(:timestamp) { Time.at(1_702_298_964).utc }
      let(:secret) { 'secret' }

      it { is_expected.to eql('11a78a4daf3d96996a022be567e444b72bf5f7462311529f0342e0f152d32803') }
    end

    context 'with some other values' do
      let(:payload) { '{"id": "EVYK7KCFJAXA23UKSG"}' }
      let(:timestamp) { Time.at(1_672_527_600).utc }
      let(:secret) { '996QF2kLfVcmF8hzikZVfeB7GPH2RdP7' }

      it { is_expected.to eql('9dfc94dfd152e5c428a5b72c27bbbada0c2d81c266b62ab93ab7087aa773729b') }
    end
  end

  describe '#verify' do
    subject(:verify) { signature_verifier.verify(signature: signature) }

    let(:signature_verifier) do
      described_class.new(
        payload: '',
        timestamp: Time.at(1_702_298_964).utc,
        secret: 'secret'
      )
    end

    context 'when signatures do not match' do
      let(:signature) { 'signature' }

      it 'raises a SignatureVerificationError' do
        expect { verify }.to raise_error(PayPro::SignatureVerificationError, 'Signature does not match')
      end
    end

    context 'when signatures match' do
      let(:signature) { '11a78a4daf3d96996a022be567e444b72bf5f7462311529f0342e0f152d32803' }

      before { Timecop.freeze(current_time) }

      after { Timecop.return }

      context 'when signature is outside the tolerance zone' do
        let(:current_time) { Time.at(1_702_300_164).utc }

        it 'raises a SignatureVerificationError' do
          expect { verify }.to raise_error(
            PayPro::SignatureVerificationError,
            'Timestamp is outside the tolerance zone: 2023-12-11 12:49:24'
          )
        end
      end

      context 'when signature is inside the tolerance zone' do
        let(:current_time) { Time.at(1_702_298_964).utc }

        it { is_expected.to be(true) }
      end
    end
  end
end
