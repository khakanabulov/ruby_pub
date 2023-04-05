# frozen_string_literal: true

class Api::Femida::NalogController < ApplicationController
  protect_from_forgery with: :null_session

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

  def company_proc(array, pbCaptchaToken = nil)
    array.map do |z|
      hash = { token: z['token'], method: 'get-request' }
      hash[:pbCaptchaToken] = pbCaptchaToken if pbCaptchaToken
      resp = load_retry('https://pb.nalog.ru/company-proc.json', prepare_hash(hash))
      next if resp.nil?

      x = JSON.parse(resp)
      hash = { token: x['token'], id: x['id'], method: 'get-response' }

      JSON.parse(load_retry('https://pb.nalog.ru/company-proc.json', prepare_hash(hash)))
    end.compact
  end

  def search_proc(hash)
    hash[:ogrFl] = 1
    hash[:ogrUl] = 1
    JSON.parse(load_retry('https://pb.nalog.ru/search-proc.json', prepare_hash(hash)))
  end

  def prepare_hash(hash)
    hash.map { |key, value| "#{key}=#{value}" }.join("&")
  end

  def captcha_proc
    z = RestClient.get('https://pb.nalog.ru/static/captcha.bin?version=2').body
    capcha = RestClient.get("https://pb.nalog.ru/static/captcha.bin?version=2&a=#{z}")
    @resp = post_rucaptcha(Base64.encode64(capcha.body), phrase: 0, regsense: 0, numeric: 1, language: 0)
    return if @resp == ApplicationController::ERROR

    proc = load_retry('https://pb.nalog.ru/captcha-proc.json', "captcha=#{@resp.split('|').last}&captchaToken=#{z}")
    proc = proc.delete("\"") if proc

    { pbCaptchaToken: proc, token: z }
  end

  def load_retry(url, payload)
    puts "--------------------------------------------------------- >>"
    puts "#{url} => #{payload}"

    x = 0
    resp = nil
    while x < RETRY
      x += 1
      resp = load(url, payload)
      resp.nil? ? sleep(1.second) : (x = RETRY)
    end
    puts "--------------------------------------------------------- <<"
    puts resp
    resp
  end

  def load(url, payload)
    RestClient::Request.execute(url: url, payload: payload, method: :post, verify_ssl: false).body
    rescue Errno::ECONNRESET, RestClient::BadRequest
  end
end
