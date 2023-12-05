# frozen_string_literal: true

module PayPro
  class Error < StandardError
    def initialize(
      message: nil,
      http_status: nil,
      http_body: nil,
      http_headers: nil,
      code: nil
    )
      @message = message
      @http_status = http_status
      @http_body = http_body
      @http_headers = http_headers
      @code = code

      super(@message)
    end
  end

  class ConnectionError < Error; end
  class AuthenticationError < Error; end
  class ResourceNotFoundError < Error; end

  class ValidationError < Error
    def initialize(param:, **kwargs)
      @param = param

      super(**kwargs)
    end
  end
end
