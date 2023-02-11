# frozen_string_literal: true

class Api::DriverController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/driver?', 'Проверка водителя'
  def index
    capcha = JSON.parse RestClient.get('https://check.gibdd.ru/captcha')
    rucaptcha = RestClient.post(
      'http://rucaptcha.com/in.php',
      { key: ENV['RUCAPTCHA_KEY'], body: capcha['base64jpg'], method: 'base64' }
    )
    id = rucaptcha.body.split('|').last
    x = 0
    resp = get(id)
    while x < 10
      x += 1
      resp = get(id)
      puts "#{x}: #{resp.body}"
      resp.body[0..1] == 'OK' ? (x = 10) : sleep(1.second)
    end
    string = "num=#{params[:num]}&date=#{params[:date]}&captchaWord=#{resp.body.split('|').last}&captchaToken=#{capcha['token']}"
    driver = JSON.parse RestClient.post('https://xn--b1afk4ade.xn--90adear.xn--p1ai/proxy/check/driver', string)
    render status: :ok, json: driver
  end

  private

  def get(id)
    RestClient.get("http://rucaptcha.com/res.php?key=#{ENV['RUCAPTCHA_KEY']}&action=get&id=#{id}")
  end
end
