# frozen_string_literal: true

class Api::Femida::WebsborController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/websbor?inn=1&okpo=2&ogrn=3', 'Проверка ФЛ на долги - json: {"error": 0, "finesList": [], "count": null, "inGarage": 0} (https://gosnalogi.ru/ajax/taxes_inn)'
  def index
    json = JSON.parse RestClient.post('https://websbor.gks.ru/webstat/api/gs/organizations', okpo: params[:okpo], inn: params[:inn], ogrn: params[:ogrn])
    render status: :ok, json: json
  end
end
