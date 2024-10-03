# frozen_string_literal: true

module PayPro
  class Webhook < Resource
    include PayPro::Operations::Deletable
    include PayPro::Operations::Updatable

    RESOURCE_PATH = 'webhooks'

    def self.create_event(
      payload:,
      signature:,
      secret:,
      timestamp:,
      tolerance: PayPro::Signature::DEFAULT_TOLERANCE
    )
      signature_verifier = PayPro::Signature.new(
        payload: payload,
        timestamp: Time.at(timestamp),
        secret: secret,
        tolerance: tolerance
      )

      return unless signature_verifier.verify(signature: signature)

      data = JSON.parse(payload)
      PayPro::Event.create_from_data(data, api_client: nil)
    end
  end
end
