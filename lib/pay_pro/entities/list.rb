# frozen_string_literal: true

module PayPro
  class List < Entity
    include Enumerable

    attr_accessor :filters

    def [](key)
      data[key]
    end

    def each(&block)
      data.each(&block)
    end

    def next(params: {})
      return List.create_from_data({ data: [] }) if next_link.nil?

      client = PayPro::Client.default_client
      params = filters.merge(params).merge(cursor: next_id)

      response = client.request(method: 'get', uri: next_uri.path, params: params)
      Util.to_entity(response.data)
    end

    def previous(params: {})
      return List.create_from_data({ data: [] }) if previous_link.nil?

      client = PayPro::Client.default_client
      params = filters.merge(params).merge(cursor: previous_id)

      response = client.request(method: 'get', uri: previous_uri.path, params: params)
      Util.to_entity(response.data)
    end

    def empty?
      data.empty?
    end

    private

    def next_id
      CGI.parse(next_uri.query)['cursor'].first
    end

    def next_uri
      @next_uri ||= URI.parse(next_link)
    end

    def next_link
      links['next']
    end

    def previous_id
      CGI.parse(previous_uri.query)['cursor'].first
    end

    def previous_uri
      @previous_uri ||= URI.parse(previous_link)
    end

    def previous_link
      @previous_link ||= links['prev']
    end
  end
end
