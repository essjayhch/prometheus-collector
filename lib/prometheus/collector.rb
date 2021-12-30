require 'prometheus/client'

require 'register'
require 'em/cron'
require 'logger'


require 'prometheus/collector/extensions'
require 'prometheus/collector/application'

module Prometheus
  module Collector
    class << self
      attr_writer :logger

      def logger
        @logger ||= Logger.new ENV.fetch('PROMETHEUS_COLLECTOR_LOGGER', STDOUT)
      end

    end
  end
end

Dir.glob("#{File.dirname(__FILE__)}/collector/extensions/*").each do |f|
  require "prometheus/collector/extensions/#{File.basename(f)}"
end

