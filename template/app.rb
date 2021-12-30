require 'prometheus/collector'

class Guage < Prometheus::Collector::Extensions::Base
  install

  def run
    counter.increment(labels: { service: 'foo'})
  end

  def counter
    return @counter if @counter
    @counter = Prometheus::Client::Counter.new(:test_counter, docstring: 'Rolling Counter', labels: [:service])
    Prometheus::Client.registry.register(@counter)
    @counter
  end
end

Prometheus::Collector::Application.start
