# frozen_string_literal: true

class Api::Femida::EsiaController < ApplicationController
  protect_from_forgery with: :null_session

  HOST = 'https://esia.gosuslugi.ru'
  PATH = 'api/public/v2'

  api :GET, "/esia?phone=79991112233&passport=1234567890 \n/esia?email=a@a.a&inn=111222333444 \n/esia?email=a@a.a&snils=111222333444", 'Проверка ЕСИА'
  def index
    type = get("/captcha/#{PATH}/type")
    headers = { captchaSession: type['captchaSession'] }
    capcha = get("/captcha/#{PATH}/image", headers, parse: false)
    resp = post_rucaptcha(Base64.encode64(capcha), phrase: 0, regsense: 0, numeric: 0, language: 1)
    headers2 = { 'Content-Type' => 'application/json', 'captchaSession' => type['captchaSession'] }
    token = JSON.parse RestClient.post("#{HOST}/captcha/#{PATH}/verify", { captchaType: type['captchaType'], answer: resp.body.split('|').last }.to_json, headers2)
    sleep 1
    json = { search_params: search_params }
    json.merge!(get("/esia-rs/#{PATH}/recovery/find?#{search_params}&verifyToken=#{token['verify_token']}"))
    json.merge!(get("/esia-rs/#{PATH}/recovery/find?#{search_params}&requestId=#{json['requestId']}", headers2))
    render status: :ok, json: json
  end

  private

  def search_params
    %i[phone email passport inn snils].map { |key| hash[key] if params[key].present? }.compact.join("&")
  end

  def hash
    {
      phone:    "mbt=+7(#{params[:phone].last(10)[0..2]})#{params[:phone].last(10).last(7)}",
      email:       "eml=#{params[:email]}",
      passport: "serNum=#{params[:passport]}",
      inn:         "inn=#{params[:inn]}",
      snils:     "snils=#{params[:snils]}"
    }
  end

  def get(path, headers = {}, parse: true)
    puts path
    resp = RestClient.get(HOST + path, headers)
    parse ? JSON.parse(resp) : resp
  rescue RestClient::NotFound, RestClient::BadRequest => e
    { error: 'not found' }
  end
end
