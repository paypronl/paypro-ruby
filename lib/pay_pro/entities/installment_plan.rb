# frozen_string_literal: true

module PayPro
  class InstallmentPlan < Resource
    include PayPro::Operations::Creatable
    include PayPro::Operations::Listable
    include PayPro::Operations::Updatable

    RESOURCE_PATH = 'installment_plans'

    def cancel
      self.class.api_request(method: 'delete', uri: resource_url)
    end

    def pause
      self.class.api_request(method: 'post', uri: "#{resource_url}/pause")
    end

    def resume
      self.class.api_request(method: 'post', uri: "#{resource_url}/resume")
    end

    def installment_plan_periods
      self.class.api_request(
        method: 'get',
        uri: "#{resource_url}/installment_plan_periods"
      )
    end
  end
end
