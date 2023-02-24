# frozen_string_literal: true

class ApplicationController < ActionController::Base
  RETRY = 10
  URL = 'http://rucaptcha.com'

  private

  def post_rucaptcha(body, attrs = {})
    params = { key: ENV['RUCAPTCHA_KEY'], body: body, method: 'base64' }
    rucaptcha = RestClient.post("#{URL}/in.php", params.merge(attrs))
    id = rucaptcha.body.split('|').last
    x = 0
    resp = get_rucaptcha(id)
    while x < RETRY
      x += 1
      resp = get_rucaptcha(id)
      puts "#{x}: #{resp.body}"
      x = RETRY if resp.body == 'ERROR_CAPTCHA_UNSOLVABLE'
      resp.body[0..1] == 'OK' ? (x = RETRY) : sleep(1.second)
    end
    resp
  end

  def get_rucaptcha(id)
    RestClient.get("#{URL}/res.php?key=#{ENV['RUCAPTCHA_KEY']}&action=get&id=#{id}")
  end
end
