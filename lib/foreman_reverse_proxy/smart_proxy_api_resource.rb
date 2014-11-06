module ForemanReverseProxy
  class SmartProxyApiResource < ::ProxyAPI::Resource
    def initialize(args)
      @url     = args[:url] + "/reverseproxy"
      super args
    end

    # returns the Template URL for this proxy
    def proxy_url
      if (response = parse(get("proxy-url")))
        return response["reverseProxyUrl"]
      end
    rescue SocketError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET,
           EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
           Net::ProtocolError, RestClient::ResourceNotFound
      logger.warn("failed to obtain reverse proxy url from smart-proxy #{@url}")
      nil
    end
  end
end
