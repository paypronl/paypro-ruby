# frozen_string_literal: true

RSpec.describe PayPro::ApiClient do
  describe '#request' do
    subject(:request) { client.request(method: method, uri: uri) }

    let(:client) { described_class.new(config) }

    let(:method) { 'get' }
    let(:uri) { '/payments' }
    let(:url) { 'https://api.paypro.nl/payments' }

    context 'when api_key is not set' do
      let(:config) { PayPro::Config.new }

      it 'raises an AuthenticationError' do
        expect { request }.to raise_error(
          PayPro::AuthenticationError,
          'API key not set. Make sure to set the API key with "PayPro.api_key = <API_KEY>". You c' \
          'an find your API key in the PayPro dashboard at "https://app.paypro.nl/developers/api-' \
          'keys".'
        )
      end

      context 'when using options' do
        subject(:request) { client.request(method: method, uri: uri, options: options) }

        let(:options) { { api_key: '4321', api_url: 'https://api-test.paypro.nl' } }
        let(:url) { 'https://api-test.paypro.nl/payments' }

        before do
          stub_request(:get, 'https://api-test.paypro.nl/payments').and_return(
            body: { success: 'True' }.to_json,
            status: 200
          )
        end

        it 'does the correct request' do
          request

          expect(
            a_request(
              :get,
              url
            ).with(
              headers: {
                'Content-Type' => 'application/json',
                'Authorization' => 'Bearer 4321'
              }
            )
          ).to have_been_made
        end
      end
    end

    context 'when api_key is set' do
      let(:config) { PayPro::Config.new.merge(api_key: '1234') }

      context 'when invalid JSON is returned with a success status' do
        before { stub_request(:get, url).to_return(body: '', status: 200) }

        it 'raises a Error' do
          expect { request }.to raise_error(
            PayPro::Error,
            'Invalid response from API. The JSON returned in the body is not valid.'
          )
        end
      end

      context 'when invalid JSON is returned with a fail status' do
        before { stub_request(:get, url).to_return(body: '', status: 500) }

        it 'raises a Error' do
          expect { request }.to raise_error(
            PayPro::Error,
            'Invalid response from API. The JSON returned in the body is not valid.'
          )
        end
      end

      context 'with status code 401' do
        before { stub_request(:get, url).to_return(status: 401, body: '{}') }

        it 'raises an AuthenticationError' do
          expect { request }.to raise_error(
            PayPro::AuthenticationError,
            'Invalid API key supplied. Make sure to set a correct API key without any whitespace a' \
            'round it. You can find your API key in the PayPro dashboard at "https://app.paypro.n' \
            'l/developers/api-keys".'
          )
        end
      end

      context 'with status code 404' do
        before { stub_request(:get, url).to_return(status: 404, body: '{}') }

        it 'raises a ResourceNotFoundError' do
          expect { request }.to raise_error(
            PayPro::ResourceNotFoundError,
            'Resource not found'
          )
        end
      end

      context 'with status code 422' do
        before do
          stub_request(:get, url).to_return(
            status: 422,
            body: {
              error: {
                message: 'Description must be set',
                param: 'description',
                type: 'invalid_request'
              }
            }.to_json
          )
        end

        it 'raises a ValidationError' do
          expect { request }.to raise_error(
            PayPro::ValidationError,
            'Description must be set, with param: "description"'
          )
        end
      end

      context 'when a timeout occurs' do
        before { stub_request(:get, url).to_timeout }

        it 'raises a PayPro::ConnectionError' do
          expect { request }.to raise_error(
            PayPro::ConnectionError,
            'Failed to make a connection to the PayPro API. This could indicate a DNS issue or be' \
            'cause you have no internet connection.'
          )
        end
      end

      context 'with headers' do
        subject(:request) { client.request(method: method, uri: uri, headers: headers) }

        let(:headers) { { 'X-Test-Header' => 'Test' } }

        before do
          stub_const('OpenSSL::VERSION', '2.2.2')
          stub_const('RUBY_VERSION', '3.0.6')

          stub_request(:get, url).and_return(status: 200, body: '{}')
        end

        it 'does the correct request' do
          request

          expect(
            a_request(:get, url).with(
              headers: {
                'X-Test-Header' => 'Test',
                'Content-Type' => 'application/json',
                'Authorization' => 'Bearer 1234',
                'User-Agent' => 'PayPro 0.1.0 / Ruby 3.0.6 / OpenSSL 2.2.2'
              }
            )
          ).to have_been_made
        end
      end

      context 'with a successful response' do
        before do
          stub_request(:get, url).and_return(
            body: { success: 'True' }.to_json,
            headers: { 'x-request-id' => '2de44ce1-2ace-4118-922e-e53ab33f6fc7' },
            status: 200
          )
        end

        it 'returns a PayPro::Response' do
          expect(request).to be_a(PayPro::Response)
        end

        it 'has the correct attributes' do
          expect(request).to have_attributes(
            status: 200,
            data: { 'success' => 'True' },
            raw_body: '{"success":"True"}',
            request_id: '2de44ce1-2ace-4118-922e-e53ab33f6fc7'
          )
        end
      end

      context 'with a post request' do
        subject(:request) do
          client.request(
            method: 'post',
            uri: uri,
            body: { amount: 500 }.to_json,
            headers: { 'X-Test-Header' => 'Test' },
            params: { limit: 1 }
          )
        end

        let(:uri) { '/customers' }
        let(:url) { 'https://api.paypro.nl/customers?limit=1' }

        before do
          stub_const('OpenSSL::VERSION', '2.2.2')
          stub_const('RUBY_VERSION', '3.0.6')

          stub_request(:post, 'https://api.paypro.nl/customers?limit=1').and_return(
            body: { success: 'True' }.to_json,
            headers: { 'x-request-id' => '2de44ce1-2ace-4118-922e-e53ab33f6fc7' },
            status: 201
          )
        end

        it 'does a correct request' do
          request

          expect(
            a_request(
              :post,
              url
            ).with(
              body: '{"amount":500}',
              headers: {
                'X-Test-Header' => 'Test',
                'Content-Type' => 'application/json',
                'Authorization' => 'Bearer 1234',
                'User-Agent' => 'PayPro 0.1.0 / Ruby 3.0.6 / OpenSSL 2.2.2'
              }
            )
          ).to have_been_made
        end
      end

      context 'when using options' do
        subject(:request) { client.request(method: method, uri: uri, options: options) }

        let(:options) { { api_key: '4321', api_url: 'https://api-test.paypro.nl' } }
        let(:url) { 'https://api-test.paypro.nl/payments' }

        before do
          stub_request(:get, 'https://api-test.paypro.nl/payments').and_return(
            body: { success: 'True' }.to_json,
            status: 200
          )
        end

        it 'does the correct request' do
          request

          expect(
            a_request(
              :get,
              url
            ).with(
              headers: {
                'Content-Type' => 'application/json',
                'Authorization' => 'Bearer 4321'
              }
            )
          ).to have_been_made
        end
      end
    end
  end
end
