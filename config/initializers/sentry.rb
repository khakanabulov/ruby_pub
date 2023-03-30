# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'http://4d74c450486d4ac8af601e6ee039d1de@femida-search.online:9000/2'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
