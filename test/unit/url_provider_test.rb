require 'test_helper'

class ForemanUrlProviderTest < ActiveSupport::TestCase
  setup do
    @url_provider = ForemanReverseProxy::ForemanUrlProvider.new
    @token = OpenStruct.new(:value => 'mytoken')
    @proxy = OpenStruct.new(:url => 'http://smartproxyurl',
                            :features =>
                              [OpenStruct.new(:name => 'Reverse Proxy')])
  end

  test "override detects reverse proxy" do
    assert_equal @url_provider.override?(@proxy), true
  end

  test "foreman_url retrieves from SmartProxyApiResource" do
    ForemanReverseProxy::SmartProxyApiResource.any_instance.
      stubs(:proxy_url).returns("https://www.example.com")

    assert_equal @url_provider.foreman_url('provision', @proxy, @token),
      "https://www.example.com:443/unattended/provision?token=mytoken"
  end
end
