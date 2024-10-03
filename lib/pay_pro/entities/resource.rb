# frozen_string_literal: true

module PayPro
  class Resource < Entity
    include PayPro::Operations::Requestable

    private

    def resource_url
      "/#{self.class::RESOURCE_PATH}/#{CGI.escape(id)}"
    end
  end
end
