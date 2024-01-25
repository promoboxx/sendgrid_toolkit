require File.expand_path("#{File.dirname(__FILE__)}/../../../helper")

describe SendgridToolkit::V3::Bounces do
  before do
    FakeWeb.clean_registry
    api_name = ENV['TEST_SMTP_USERNAME'] || 'fakeuser'
    api_key = ENV['TEST_SMTP_PASSWORD'] || 'fakepass'
    @obj = SendgridToolkit::V3::Bounces.new("fakeuser", "fakepass")
  end

  describe "#retrieve" do
    it "returns array of bounced emails" do
      FakeWeb.register_uri(:get, "https://#{REGEX_ESCAPED_BASE_URI_V3}/suppressions/bounces", query: {})
      bounces = @obj.get
    end
  end
end
