require 'foreman_reverse_proxy/smart_proxy_api_resource'

module ForemanReverseProxy
  class ForemanUrlProvider
    include ActionView::Helpers
    include ActionDispatch::Routing
    include Rails.application.routes.url_helpers
    include Foreman::Controller::ForemanUrlRenderable

    def override?(proxy)
      proxy && proxy.try(:features).map(&:name).include?('Reverse Proxy')
    end

    def foreman_url(action, proxy, token)
      url = ForemanReverseProxy::SmartProxyApiResource.new(:url => proxy.url).proxy_url
      raise 'could not obtain reverse proxy url from proxy' if url.nil?
      foreman_url_from_uri(action, url, token)
    end
  end
end

