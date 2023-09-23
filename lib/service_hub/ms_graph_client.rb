require 'faraday'

module ServiceHub
  class MsGraphClient
    CONTENT_TYPE = 'application/json'.freeze
    TIMEOUT = 5
    STATUS_CODES_400 = (400..499).to_a.freeze

    def initialize(access_token, payload)
      @access_token = access_token
      @payload = payload
    end

    def send_email
      @last_response = Faraday.post(send_email_endpoint) do |req|
        req.headers['Content-Type'] = CONTENT_TYPE
        req.headers['Authorization'] = "Bearer #{access_token}"
        req.options['timeout'] = TIMEOUT
        req.body = payload.to_json
      end

      handle_response
    end

    private

    attr_reader :access_token, :payload, :client, :last_response

    def send_email_endpoint
      Rails.configuration.custom_config['ms_graph_send_email_endpoint']
    end

    def handle_response
      case last_response.status
      when 401
        err_message = JSON.parse(last_response.body)
        Rails.logger.error("Faraday::AuthorizationError: status code #{last_response.status}")
        Rails.logger.error(err_message)
        raise AuthorizationError.new(err_message)
      when 500
        err_message = JSON.parse(last_response.body)
        Rails.logger.error("Faraday::ServerError: status code #{last_response.status}")
        Rails.logger.error(err_message)
        raise ServerError.new(err_message)
      when STATUS_CODES_400
        Rails.logger.error("Faraday::Error: status code #{last_response.status}")
        Rails.logger.error(err_message)
      end

      last_response.success?
    end

    class AuthorizationError < StandardError; end
    class Error < StandardError; end
    class ServerError < StandardError; end
  end
end
