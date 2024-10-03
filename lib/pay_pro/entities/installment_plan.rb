# frozen_string_literal: true

module PayPro
  class InstallmentPlan < Resource
    include PayPro::Operations::Updatable

    RESOURCE_PATH = 'installment_plans'

    def cancel(**options)
      api_request(method: 'delete', uri: resource_url, options: options)
    end

    def pause(**options)
      api_request(method: 'post', uri: "#{resource_url}/pause", options: options)
    end

    def resume(**options)
      api_request(method: 'post', uri: "#{resource_url}/resume", options: options)
    end

    def installment_plan_periods(**options)
      api_request(
        method: 'get',
        uri: "#{resource_url}/installment_plan_periods",
        options: options
      )
    end
  end
end
