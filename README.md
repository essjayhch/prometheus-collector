Application to gather prometheus style metrics

# Usage

Install  the gem into your gemfile

```gem prometheus-collector```

Install your gemset

```bundle install```

Consume the program.


```
require 'prometheus/collector'

class Guage < Prometheus::Collector::Extensions::Base
  install

  def run
    # Do some things that would be collected in Prometheus::Client Objects
  end
end
```

Mount the Prometheus::Collector::Application application, or start it from your app.rb

```
Prometheus::Collector::Application.start
```

# How it works

The collector app makes use of the Prometheus client collector and exporter middleware to allow you to write custom applications that export prometheus style metrics.

It is designed as a bare-bones scaffold to get you off the ground with a ruby applet to get some statistics.

It utilizes rack and its middleware.

The interface is fairly straightforward: Your Metric Executing code needs to extend Prometheus::Collector::Extensions::Base for 'repeatedly-runbable' operations and Prometheus::Collector::Extensions::Once for something that should only be executed Once.

Your class should implement an instance level `run` function, and may optionally implement a class level `schedule` function: This must return a `cron` style string to tell the application when to invoke your `run` code. By default, `schedule` is set to `* * * * *` which would allow the code to be executed every minute.

### Scheduling
Scheduling is implemented via em-cron. Thus the re-scheduling of a task should occur within the parameters of the `schedule` string but is evaluated upon completion. Thus in normal operation, the code should not execute more than one `run` of a given worker definition at a time.
