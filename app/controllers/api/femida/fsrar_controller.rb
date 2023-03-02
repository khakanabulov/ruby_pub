# frozen_string_literal: true

class Api::Femida::FsrarController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/fsrar/:inn', 'Проверка ФЛ - json: {} (https://fsrar.gov.ru)'
  def show
    resp = RestClient.get("https://fsrar.gov.ru/opendata/#{params[:id]}-reestr")
    parsed_data = Nokogiri::HTML.parse(resp)
    # parsed_data.css('tr').map do |x|
    #   text = parsed_data.css('.administrative span').children[0].text
    #   date = DatesFromString.new.find_date(text).first
    #   dt = begin
    #          date&.to_date ? date.to_date.strftime('%d.%m.%Y') : ''
    #        rescue
    #          nil
    #        end
    #   link  = parsed_data.css('.num_case')[0].attributes['href'].value
    #   num   = parsed_data.css('.num_case').children[0].text.delete("\r\n\t\s")
    #   judge = parsed_data.css('.court .b-container .judge').children[0].text
    #   title = parsed_data.css('.court .b-container div:not(.judge)').children[0].text
    #   name  = parsed_data.css('.js-rollover.b-newRollover').children[0].text.delete("\r\n\t").split.join(' ')
    #   { link: link, num: num, judge: judge, title: title, name: name, dt: dt }
    # end

    render status: :ok, json: parsed_data
  end
end
