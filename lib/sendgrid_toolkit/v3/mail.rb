require 'json'

module SendgridToolkit
  module V3
    class Mail < SendgridToolkit::V3::AbstractSendgridClient
      def send_mail(options = {})
        response = api_post('mail/send', convert_params(options))
        fail(SendgridToolkit::SendEmailError, response['error']) if response.key?('errors')
        response
      end

      private

      def convert_params(options)
        options["x-smtpapi"] = options["x-smtpapi"].to_json if options.has_key?("x-smtpapi")
        options
      end
    end
  end
end
