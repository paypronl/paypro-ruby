# frozen_string_literal: true

module PayPro
  class Signature
    # Default timestamp tolerance is 10 minutes
    DEFAULT_TOLERANCE = 600

    def initialize(
      payload:,
      timestamp:,
      secret:,
      tolerance: DEFAULT_TOLERANCE
    )
      raise ArgumentError, 'timestamp must be an instance of Time' unless timestamp.is_a?(Time)
      raise ArgumentError, 'payload must be a String' unless payload.is_a?(String)
      raise ArgumentError, 'secret must be a String' unless secret.is_a?(String)
      raise ArgumentError, 'tolerance must be an Integer' unless tolerance.is_a?(Integer)

      @payload = payload
      @timestamp = timestamp
      @secret = secret
      @tolerance = tolerance
    end

    def generate_signature
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'),
        @secret,
        signature_string
      )
    end

    def verify(signature:)
      unless OpenSSL.secure_compare(signature, generate_signature)
        raise SignatureVerificationError.new(
          message: 'Signature does not match',
          http_body: @payload
        )
      end

      if @timestamp < Time.now - @tolerance
        formatted_timestamp = @timestamp.strftime('%F %T')

        raise SignatureVerificationError.new(
          message: "Timestamp is outside the tolerance zone: #{formatted_timestamp}",
          http_body: @payload
        )
      end

      true
    end

    private

    def signature_string
      "#{@timestamp.to_i}.#{@payload}"
    end
  end
end
