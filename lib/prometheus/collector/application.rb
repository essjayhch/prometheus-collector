require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
require 'rack'
module Prometheus
  module Collector
    class Application
      def self.app
        Rack::Builder.app do
          use Rack::Deflater
          use Prometheus::Middleware::Collector
          use Prometheus::Middleware::Exporter
          run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['OK']] }
        end
      end

      def self.start
        initialize_static_extensions
        initialize_runnable_extensions
        Rack::Server.start(
          app: app, Port: 9292
        )
      end

      def self.initialize_static_extensions
        Prometheus::Collector.logger.info "Initializing Static Extensions"
        Extensions.values.each do |o|
          Prometheus::Collector.logger.info "Initializing #{o.class.name}"
          begin
            o.callback.call o.call
          rescue => e
            o.errback.call e
          end
        end
        Prometheus::Collector.logger.info "Done initializing Static Extensions"
      end

      def self.initialize_runnable_extensions
        Prometheus::Collector.logger.info "Initializing Runnable Extensions"
        Thread.new do
          EM.run do
            Extensions::Runnable.values.each do |o|
              Prometheus::Collector.logger.info "Initializing #{o.class.name}"
              EM::Cron.schedule(o.class.schedule) do |time|
                EM.defer(o, o.callback, o.errback)
              end
            end
          end
        end
      end
    end
  end
 end
