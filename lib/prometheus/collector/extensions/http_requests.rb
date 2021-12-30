class HTTPRequests < Prometheus::Collector::Extensions::Once
  install

  def run
    return if @requests
    @requests = Prometheus::Client::Counter.new(:http_requests, docstring: 'A counter of HTTP Requests')
   # Prometheus::Client.registry.register(@requests)
  end
end
