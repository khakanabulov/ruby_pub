# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name                = 'femida api'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/api/docs'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"

  config.languages = ['ru', 'en']
  config.default_locale = 'ru'
end
