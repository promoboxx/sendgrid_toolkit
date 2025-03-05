module SendgridToolkit
  module V3
    class Bounces < SendgridToolkit::V3::AbstractSendgridClient
      def get(opts = {})
        action_name = 'supressions/bounces'
        response = api_get(action_name, opts)
        fail(SendgridToolkit::APIError, response['error']) if response.is_a?(Hash) && response.key?('errors')
        response
      end
    end
  end
end
