# frozen_string_literal: true

class Api::NalogController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/nalog/:inn', 'Проверка ФЛ на дисквалификацию, ограничение и ИП (https://pb.nalog.ru/search-proc.json)'
  def show
    @errors = []
    resp = begin
             load
           rescue Errno::ECONNRESET => e
             load
           end

    data = JSON.parse(resp)
    data.delete 'captchaRequired'
    # data = json.filter { |_, value| value['rowCount'] > 0 }
    data.each do |key, value|
      data[key] = value['rowCount'] > 0 ? value['data'].map { |v| transform(key, v) } : []
    end

    render status: :ok, json: data.merge(success: data.size, error: @errors)
  end

  private

  def load
    RestClient.post('https://pb.nalog.ru/search-proc.json', "mode=search-all&queryAll=#{params[:id]}&queryUl=&okvedUl=&statusUl=&regionUl=&isMspUl=&mspUl1=1&mspUl2=2&mspUl3=3&queryIp=&okvedIp=&statusIp=&regionIp=&isMspIp=&mspIp1=1&mspIp2=2&mspIp3=3&uprType1=1&uprType0=1&ogrFl=1&ogrUl=1&npTypeDoc=1")
  end

  def transform(key, data)
    case key
    when 'uchr'
      {
        type:   data['type'],
        ul_cnt: data['ul_cnt'],
        name:   data['name']
      }
    when 'upr'
      data
    when 'ul'
      {
        region:     data['regionname'],
        okved:      data['okved2'],
        okved_name: data['okved2name'],
        full_name:  data['namep'],
        name:       data['namec']
      }
    when 'ogrfl'
      data
    when 'docul'
      data
    when 'rdl'
      data
    when 'addr'
      data
    when 'docip'
      data
    when 'ogrul'
      data
    when 'ip'
      {
        ogrn:       data['ogrn'],
        okved:      data['okved2'],
        okved_name: data['okved2name'],
        name:       data['namec']
      }
    end
  end
end
