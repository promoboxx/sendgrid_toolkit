module SendgridToolkit
  class AbstractSendgridClient

    def initialize(api_user = nil, api_key = nil)
      @api_user = api_user || SendgridToolkit.api_user || ENV['SMTP_USERNAME']
      @api_key = api_key || SendgridToolkit.api_key || ENV['SMTP_PASSWORD']

      raise SendgridToolkit::NoAPIUserSpecified if @api_user.nil? || @api_user.length == 0
      raise SendgridToolkit::NoAPIKeySpecified if @api_key.nil? || @api_key.length == 0
    end

    protected

    def api_post(module_name, action_name, opts = {})
      base_path = compose_base_path(module_name, action_name)
      response = nil
      if (@api_user == "apikey")
        response = HTTParserParty.post("https://#{BASE_URI}/#{base_path}.json?", :body => opts, :format => :json, :headers => { "Authorization" => "Bearer #{@api_key}"})
      else
        response = HTTParserParty.post("https://#{BASE_URI}/#{base_path}.json?", :body => get_credentials.merge(opts), :format => :json)
      end

      if response.code > 401
        raise(SendgridToolkit::SendgridServerError, "The SendGrid server returned an error. #{response.inspect}")
      elsif has_error?(response) &&
          response['error'].respond_to?(:has_key?) &&
          response['error'].has_key?('code') &&
          response['error']['code'].to_i == 401
        raise SendgridToolkit::AuthenticationFailed
      elsif has_error?(response)
        raise(SendgridToolkit::APIError, response['error'])
      end
      response
    end

    def get_credentials
      {:api_user => @api_user, :api_key => @api_key}
    end

    def compose_base_path(module_name, action_name)
      "#{module_name}.#{action_name}"
    end

    private
    def has_error?(response)
      response != nil && response.respond_to?(:key?) && response.key?('error')
    end
  end
end
