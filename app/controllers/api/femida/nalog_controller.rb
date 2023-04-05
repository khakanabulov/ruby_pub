# frozen_string_literal: true

class Api::Femida::NalogController < ApplicationController
  protect_from_forgery with: :null_session

  HOST = 'https://pb.nalog.ru/'
  RETRY = 5

  api :GET, '/nalog/ogr?id=:inn', 'Проверка на ограничение' # 668608997290
  def ogr
    hash = captcha_proc
    hash[:mode] = 'search-ogr'
    hash[:queryOgr] = params[:id]
    d = search_proc(hash)
    data = d['ogrfl']['data'] + d['ogrul']['data']
    render status: :ok, json: { data: data, company: company_proc(data) }
    # {"success":0,"limit_org":[{"name":"","inn":"","position":"","reason":"","start_date":"","end_date":"","org_name":"","org_inn":""}],"error":""}
  end

  api :GET, '/nalog/uchr?id=:inn', 'Проверка на учредителей и гендиректоров' # 502419236001
  def uchr
    hash = captcha_proc
    hash[:mode] = 'search-upr-uchr'
    hash[:queryUpr] = params[:id]
    hash[:uprType0] = 1
    hash[:uprType1] = 1
    d = search_proc(hash)
    data = d['uchr']['data'] + d['upr']['data']
    resp = data.map do |z|
      hash = { pbCaptchaToken: hash[:pbCaptchaToken], token: z['token'], mode: 'search-ul', queryUpr: z['inn'] }
      x = search_proc(hash)
      next unless x

      x['ul']['data']
    end.compact.flatten
    render status: :ok, json: { data: data, resp: resp, company: company_proc(resp, hash[:pbCaptchaToken]) }
    # {"success":0,"director":[{"inn":"","name":"","count":0}],"owner":[{"inn":"","name":"","count":0}],"error":""}
  end

  api :GET, '/nalog/ip?id=:inn', 'Проверка на ИП' # 772830410106
  def ip

    # {"success":0,"ip":[{"ogrn":"","okved":"","okved_name":"","name":""}],"error":""}
  end

  api :GET, '/nalog/rdl?id=:inn', 'Проверка на дисквалификацию' # 5205037677
  def rdl

    # {"success":0,"dis":[{"number":"","name":"","date_of_birth":"","place_of_birth":"","name_org":"","position":"","article":"","creator":"","court":"","period":"","start_date":"","end_date":""}],"error":""}
  end

  private

  def company_proc(array, pb = nil)
    array.map do |z|
      hash = { token: z['token'], method: 'get-request' }
      hash[:pbCaptchaToken] = pb if pb
      x = load_retry(:company, hash)
      next if x.nil?

      hash = { token: x['token'], id: x['id'], method: 'get-response' }
      load_retry(:company, hash)
    end.compact
  end

  def search_proc(hash)
    hash[:ogrFl] = 1
    hash[:ogrUl] = 1
    load_retry(:search, hash)
  end

  def captcha_proc
    z = RestClient.get("#{HOST}static/captcha.bin?version=2").body
    captcha = RestClient.get("#{HOST}static/captcha.bin?version=2&a=#{z}")
    @resp = post_rucaptcha(Base64.encode64(captcha.body), phrase: 0, regsense: 0, numeric: 1, language: 0)
    return if @resp == ApplicationController::ERROR

    captcha = load_retry(:captcha, { captcha: @resp.split('|').last, captchaToken: z })
    { pbCaptchaToken: captcha, token: z }
  end

  def load_retry(url, hash)
    puts "--------------------------------------------------------- => #{url}"
    puts hash

    x = 0
    resp = nil
    while x < RETRY
      x += 1
      resp = load(url, hash)
      resp.nil? ? sleep(1.second) : (x = RETRY)
    end
    puts "\n <= ..... #{resp}"
    JSON.parse(resp) if resp.present?
  end

  def load(url, hash = {})
    RestClient::Request.execute(
      url: "#{HOST}#{url}-proc.json",
      payload: hash.map { |key, value| "#{key}=#{value}" }.join("&"),
      method: :post,
      verify_ssl: false
    ).body
    rescue Errno::ECONNRESET, RestClient::BadRequest
  end
end
