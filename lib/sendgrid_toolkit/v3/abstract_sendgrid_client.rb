module SendgridToolkit
  module V3
    class AbstractSendgridClient

      BASE_URI = 'https://api.sendgrid.com/v3'

      def initialize(api_user = nil, api_key = nil)
        @api_user = api_user || SendgridToolkit.api_user || ENV['SMTP_USERNAME']
        @api_key = api_key || SendgridToolkit.api_key || ENV['SMTP_PASSWORD']

        fail SendgridToolkit::NoAPIUserSpecified if @api_user.nil? || @api_user.length == 0
        fail SendgridToolkit::NoAPIKeySpecified if @api_key.nil? || @api_key.length == 0
      end

      protected

      def api_post(action_name, options = {})
        if (@api_user == "apikey")
          response = HTTParserParty.post("#{BASE_URI}/#{action_name}",
            body: options.to_json, format: :json,
            headers: { 'Authorization' => "Bearer #{@api_key}" })
        else
          response = HTTParserParty.post("#{BASE_URI}/#{action_name}",
            body: options.to_json, format: :json,
            headers: { 'Authorization' => "Basic #{credentials}" })
        end
        check_response(response)
      end

      def api_get(action_name, options = {})
        if (@api_user == "apikey")
          response = HTTParserParty.get("#{BASE_URI}/#{action_name}",
            query: options, format: :json,
            headers: { 'Authorization' => "Bearer #{@api_key}" })
        else
          response = HTTParserParty.get("#{BASE_URI}/#{action_name}",
            query: options, format: :json,
            headers: { 'Authorization' => "Basic #{credentials}" })
        end
        check_response(response)
      end

      def api_delete(action_name, options = {})
        if (@api_user == "apikey")
          response = HTTParserParty.delete("#{BASE_URI}/#{action_name}",
            body: options, format: :json,
            headers: { 'Authorization' => "Bearer #{@api_key}" })
        else
          response = HTTParserParty.delete("#{BASE_URI}/#{action_name}",
            body: options, format: :json,
            headers: { 'Authorization' => "Basic #{credentials}" })
        end
        check_response(response)
      end

      private

      def check_response(response)
        if response.code > 401
          fail(SendgridToolkit::SendgridServerError, "The SendGrid server returned an error. #{response.inspect}")
        elsif has_error?(response) &&
            response['error'].respond_to?(:has_key?) &&
            response['error'].has_key?('code') &&
            response['error']['code'].to_i == 401
          fail SendgridToolkit::AuthenticationFailed
        elsif has_error?(response)
          fail(SendgridToolkit::APIError, response['error'])
        end
        response
      end

      def credentials
        Base64.encode64("#{@api_user}:#{@api_key}")
      end

      def has_error?(response)
        response != nil && response.respond_to?(:key?) && response.key?('error')
      end
    end
  end
end
