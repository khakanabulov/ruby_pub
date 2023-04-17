# frozen_string_literal: true

class Api::Femida::NpdController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/npd/:inn', 'Проверка самозанятого - json: {"status": boolean, "message": string} (https://npd.nalog.ru/check-status/)'
  def show
    with_error_handling do
      body = RestClient.post(
        'https://statusnpd.nalog.ru/api/v1/tracker/taxpayer_status',
        { inn: params[:id].to_s, requestDate: params[:date] || Date.current.to_s }.to_json,
        content_type: 'application/json'
      )
      JSON.parse(body)
    end
  end
end
