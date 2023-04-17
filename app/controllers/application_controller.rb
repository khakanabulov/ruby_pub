# frozen_string_literal: true

class ApplicationController < ActionController::Base
  RETRY = 30
  URL = 'http://rucaptcha.com'
  ERROR = 'ERROR_CAPTCHA_UNSOLVABLE'
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
      x = RETRY if resp.body == ERROR
      resp.body[0..1] == 'OK' ? (x = RETRY) : sleep(1.second)
    end
    resp.body
  end

  def get_rucaptcha(id)
    RestClient.get("#{URL}/res.php?key=#{ENV['RUCAPTCHA_KEY']}&action=get&id=#{id}")
  end

  def with_error_handling
    error = nil
    body = begin
             yield
           rescue Errno::ECONNRESET, RestClient::NotFound, RestClient::BadRequest, StandardError, LoadError, Exception => e
             error = e.message
           end
    render status: :ok, json: error.present? ? { status: false, error: error } : body
  end
end
