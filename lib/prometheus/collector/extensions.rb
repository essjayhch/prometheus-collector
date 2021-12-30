require 'register'

module Prometheus
  module Collector
    module Extensions
      include Register
      module Runnable
        include Register
      end

      class Base
        class << self
          attr_writer :logger, :schedule

          def logger
            @logger ||= Prometheus::Collector.logger
          end

          def schedule
            @schedule ||= '* * * * *'
          end

          def install
            logger.info "Install #{name.to_sym}"
            Prometheus::Collector::Extensions::Runnable.register name.to_sym, new
          end
        end

        def log(msg, level: :info)
          self.class.logger.send(level, self.class) { msg } if self.class.logger
        end

        def call
          log 'Starting call'
          run
        end

        def run
          raise 'Not Implemented - please implement a run function'
        end

        def callback
          proc { log 'Finished call' }
        end

        def errback
          proc do |error|
            log "Exception in call: '#{error}'", level: :error
            log 'Backtrace:', level: :debug
            error.backtrace.each do |l|
              log l, level: :debug
            end
          end
        end
      end

      class Once < Base
        class << self
          def install
            logger.info "Install #{name.to_sym}"
            Prometheus::Collector::Extensions.register name.to_sym, new
          end
        end

        def call
          log 'Installing Runner Once'
          run
        end

        def callback
          proc { log 'Finished Installing Runner Once' }
        end
      end
    end
  end
end
