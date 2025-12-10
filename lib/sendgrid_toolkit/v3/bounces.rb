module SendgridToolkit
  module V3
    class Bounces < SendgridToolkit::V3::AbstractSendgridClient
      def get(options = {})
        action_name = 'suppression/bounces'
        response = api_get(action_name, options)
        fail(SendgridToolkit::APIError, response['error']) if response.is_a?(Hash) && response.key?('errors')
        response
      end
    end
  end
end
