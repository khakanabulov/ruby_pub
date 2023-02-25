# frozen_string_literal: true

class Api::Femida::EsiaController < ApplicationController
  protect_from_forgery with: :null_session

  HOST = 'https://esia.gosuslugi.ru'
  PATH = 'api/public/v2'

  api :GET, '/esia?phone=79991112233&passport=1234567890 /esia?email=a@a.a&inn=111222333444', 'Проверка ЕСИА'
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
             else
               "eml=#{params[:email]}"
             end
    sleep 1
    json = get("/esia-rs/#{PATH}/recovery/find?#{search}&verifyToken=#{token['verify_token']}")
    document = if params[:passport]
                 "serNum=#{params[:passport]}"
               elsif params[:inn]
                 "inn=#{params[:inn]}"
               elsif params[:snils]
                 "snils=#{params[:snils]}"
               end
    resp = get("/esia-rs/#{PATH}/recovery/find?#{document}&requestId=#{json['requestId']}", headers2)
    render status: :ok, json: resp
  end

  private

  def get(path, headers = {}, parse: true)
    puts path
    resp = RestClient.get(HOST + path, headers)
    parse ? JSON.parse(resp) : resp
  end
end
