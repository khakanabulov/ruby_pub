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
    sleep 7.seconds
    resp = RestClient.get("http://rucaptcha.com/res.php?key=#{ENV['RUCAPTCHA_KEY']}&action=get&id=#{id}")
    string = "num=#{params[:num]}&date=#{params[:date]}&captchaWord=#{resp.body.split('|').last}&captchaToken=#{capcha['token']}"
    driver = JSON.parse RestClient.post('https://xn--b1afk4ade.xn--90adear.xn--p1ai/proxy/check/driver', string)
    render status: :ok, json: driver
  end
end
