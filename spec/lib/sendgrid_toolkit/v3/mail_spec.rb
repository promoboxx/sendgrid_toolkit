require File.expand_path("#{File.dirname(__FILE__)}/../../../helper")

describe SendgridToolkit::V3::Mail do
  before do
    FakeWeb.clean_registry
    api_name = ENV['TEST_SMTP_USERNAME'] || 'apikey'
    api_key = ENV['TEST_SMTP_PASSWORD'] || 'fakepass'
    @obj = SendgridToolkit::V3::Mail.new(api_name, api_key)
  end

  describe "#send_mail" do
    it "raises error when sendgrid returns an error" do
      FakeWeb.register_uri(:post, "https://#{REGEX_ESCAPED_BASE_URI_V3}/mail/send", :body => '{"message": "error", "errors": ["Missing destination email"]}')
      lambda {
        response = @obj.send_mail :from => "testing@fiverr.com", :subject => "Subject", :text => "Text", "x-smtpapi" => {:category => "Testing", :to => ["elad@fiverr.com"]}
      }.should raise_error SendgridToolkit::SendEmailError
    end

    it "posts x-smtpapi parameters as json" do
      FakeWeb.register_uri(:post, "https://#{REGEX_ESCAPED_BASE_URI_V3}/mail/send", :body => '{"message":"success"}')
      xsmtpapi = {:category => "Testing", :to => ["scottb@sendgrid.com"]}
      response = @obj.send_mail :to => "scottb@sendgrid.com", :from => "testing@fiverr.com", :subject => "Subject", :text => "Text", "x-smtpapi" => xsmtpapi
      JSON.parse(response.request.options[:body])["x-smtpapi"].should == xsmtpapi.to_json
    end
  end
end
