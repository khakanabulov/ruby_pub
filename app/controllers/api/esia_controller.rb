# frozen_string_literal: true

class Api::EsiaController < ApplicationController
  protect_from_forgery with: :null_session

  URL = 'http://rucaptcha.com'
  HOST = 'https://esia.gosuslugi.ru'
  PATH = 'api/public/v2'

  api :GET, '/esia?phone=1234567890 /esia?email=a@a.a', 'Проверка ЕСИА'
  def index
    type = JSON.parse RestClient.get("#{HOST}/captcha/#{PATH}/type")
    headers = { captchaSession: type['captchaSession'] }
    capcha = RestClient.get("#{HOST}/captcha/#{PATH}/image", headers)
    rucaptcha = RestClient.post(
      "#{URL}/in.php",
      { key: ENV['RUCAPTCHA_KEY'], body: Base64.encode64(capcha), method: 'base64',
        phrase: 0, regsense: 0, numeric: 0, language: 1
      }
    )
    id = rucaptcha.body.split('|').last
    x = 0
    resp = get(id)
    while x < 30
      x += 1
      resp = get(id)
      puts "#{x}: #{resp.body}"
      x = 30 if resp.body == 'ERROR_CAPTCHA_UNSOLVABLE'
      resp.body[0..1] == 'OK' ? (x = 30) : sleep(1.second)
    end
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

  private

  def get(id)
    RestClient.get("#{URL}/res.php?key=#{ENV['RUCAPTCHA_KEY']}&action=get&id=#{id}")
  end
end
