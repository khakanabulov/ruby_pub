# frozen_string_literal: true

class Api::Femida::InnController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/inn/:inn', 'Проверка ФЛ на долги - json: {"error": 0, "finesList": [], "count": null, "inGarage": 0} (https://gosnalogi.ru/ajax/taxes_inn)'
  def show
    json = JSON.parse RestClient::Request.execute(url: "https://gosnalogi.ru/ajax/taxes_inn?inn=#{params[:id]}", method: :get, verify_ssl: false)
    json['error'] = json['error'].to_i
    render status: :ok, json: json
  end
end
