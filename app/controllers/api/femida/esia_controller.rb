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
    search = if params[:phone]
               phone = params[:phone].last(10)
               "mbt=+7(#{phone[0..2]})#{phone.last(7)}"
             elsif params[:email]
               "eml=#{params[:email]}"
             elsif params[:passport]
               "serNum=#{params[:passport]}"
             elsif params[:inn]
               "inn=#{params[:inn]}"
             elsif params[:snils]
               "snils=#{params[:snils]}"
             end
    sleep 1
    json = {}
    json.merge!(get("/esia-rs/#{PATH}/recovery/find?#{search}&verifyToken=#{token['verify_token']}")) if search
    document = if params[:passport]
                 "serNum=#{params[:passport]}"
               elsif params[:inn]
                 "inn=#{params[:inn]}"
               elsif params[:snils]
                 "snils=#{params[:snils]}"
               end
    json.merge!(get("/esia-rs/#{PATH}/recovery/find?#{document}&requestId=#{json['requestId']}", headers2)) if document
    render status: :ok, json: json
  end

  private

  def get(path, headers = {}, parse: true)
    puts path
    resp = RestClient.get(HOST + path, headers)
    parse ? JSON.parse(resp) : resp
  rescue RestClient::NotFound, RestClient::BadRequest => e
    errors = { 400 => 'passport or snils or inn not found', 404 => 'user not found' }
    { error: errors[e.http_code] }
  end
end
