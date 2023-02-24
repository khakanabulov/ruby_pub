# frozen_string_literal: true

class Api::EsiaController < ApplicationController
  protect_from_forgery with: :null_session

  HOST = 'https://esia.gosuslugi.ru'
  PATH = 'api/public/v2'
  RETRY = 30

  api :GET, '/esia?phone=1234567890 /esia?email=a@a.a', 'Проверка ЕСИА'
  def index
    type = JSON.parse RestClient.get("#{HOST}/captcha/#{PATH}/type")
    headers = { captchaSession: type['captchaSession'] }
    capcha = RestClient.get("#{HOST}/captcha/#{PATH}/image", headers)
    resp = post_rucaptcha(Base64.encode64(capcha), phrase: 0, regsense: 0, numeric: 0, language: 1)
    headers2 = { 'Content-Type' => 'application/json', 'captchaSession' => type['captchaSession'] }
    token = JSON.parse RestClient.post("#{HOST}/captcha/#{PATH}/verify", { captchaType: type['captchaType'], answer: resp.body.split('|').last }.to_json, headers2)
    search = if params[:phone]
               phone = params[:phone].last(10)
               "mbt=+7(#{phone[0..2]})#{phone.last(7)}"
             else
               "eml=#{params[:email]}"
             end
    json = JSON.parse RestClient.get("#{HOST}/esia-rs/#{PATH}/recovery/find?#{search}&verifyToken=#{token['verify_token']}")
    document = if params[:passport]
                 "serNum=#{params[:passport]}"
               elsif params[:inn]
                 "inn=#{params[:inn]}"
               elsif params[:snils]
                 "snils=#{params[:snils]}"
               end
    resp = JSON.parse RestClient.get("#{HOST}/esia-rs/#{PATH}/recovery/find?#{document}&requestId=#{json['requestId']}", headers2)
    render status: :ok, json: resp
  end
end
