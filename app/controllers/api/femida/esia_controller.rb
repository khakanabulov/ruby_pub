# frozen_string_literal: true

class Api::Femida::EsiaController < ApplicationController
  protect_from_forgery with: :null_session

  HOST = 'https://esia.gosuslugi.ru'
  PATH = 'api/public/v2'

  api :GET, "/esia?phone=79991112233&passport=1234567890&email=mail@example.com&inn=111222333444&snils=111222333444&inn=111222333444", 'Проверка ЕСИА'
  def index
    type = get("/captcha/#{PATH}/type")
    headers = { captchaSession: type['captchaSession'] }
    capcha = get("/captcha/#{PATH}/image", headers: headers, parse: false)
    resp = post_rucaptcha(Base64.encode64(capcha), phrase: 0, regsense: 0, numeric: 0, language: 1)
    headers2 = { 'Content-Type' => 'application/json', 'captchaSession' => type['captchaSession'] }
    token = JSON.parse RestClient.post("#{HOST}/captcha/#{PATH}/verify", { captchaType: type['captchaType'], answer: resp.body.split('|').last }.to_json, headers2)
    json = {}
    hash.each do |key, value|
      z1 = get("/esia-rs/#{PATH}/recovery/find?#{value}&verifyToken=#{token['verify_token']}", key: key)
      json.merge!( key => (z1['description'] == "Найдена стандартная/подтвержденная УЗ" && z1['status'] == 2))
      z2 = get("/esia-rs/#{PATH}/recovery/find?#{search_params}&requestId=#{z1['requestId']}", headers: headers2, key: key)
      json.merge!( "#{key}_info" => z2)
    end
    render status: :ok, json: json
  end

  private

  def search_params
    %i[passport inn snils].map { |key| hash[key] if params[key].present? }.compact.join('&')
  end

  def hash
    h = {}
    h[:phone]    = "mbt=+7(#{params[:phone].last(10)[0..2]})#{params[:phone].last(10).last(7)}" if params[:phone]
    h[:email]    =    "eml=#{params[:email]}"                                                   if params[:email]
    h[:passport] = "serNum=#{params[:passport]}"                                                if params[:passport]
    h[:inn]      =    "inn=#{params[:inn]}"                                                     if params[:inn]
    h[:snils]    =  "snils=#{params[:snils]}"                                                   if params[:snils]
    h
  end

  def get(path, headers: {}, parse: true, key: nil)
    puts path
    resp = RestClient.get(HOST + path, headers)
    parse ? JSON.parse(resp) : resp
  rescue RestClient::NotFound, RestClient::BadRequest => e
    { key => false }
  end
end
