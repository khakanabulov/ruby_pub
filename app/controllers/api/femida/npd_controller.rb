# frozen_string_literal: true

class Api::Femida::NpdController < ApplicationController
  RETRY = 5

  protect_from_forgery with: :null_session

  api :GET, '/npd/:inn', 'Проверка самозанятого - json: {"status": boolean, "message": string} (https://npd.nalog.ru/check-status/)'
  def show
    x = 0
    while x < RETRY
      @error = nil
      x += 1
      resp = post_request
      puts x
      resp.try(:code) == 200 ? (x = RETRY) : sleep(1.second)
    end

    render status: :ok, json: @error.present? ? { status: false, error: @error } : JSON.parse(resp.body)
  end

  private

  def post_request
    RestClient.post(
      'https://statusnpd.nalog.ru/api/v1/tracker/taxpayer_status',
      { inn: params[:id].to_s, requestDate: params[:date] || Date.current.to_s }.to_json,
      content_type: 'application/json'
    )
  rescue RestClient::UnprocessableEntity => e
    @error = e.message
  end
end
