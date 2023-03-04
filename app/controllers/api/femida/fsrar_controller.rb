# frozen_string_literal: true

class Api::Femida::FsrarController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/fsrar/:inn', 'Проверка ФЛ - json: {} (https://fsrar.gov.ru)'
  def show
    resp = RestClient.get("https://fsrar.gov.ru/opendata/#{params[:id]}-reestr")
    parsed_data = Nokogiri::HTML.parse(resp)
    array = parsed_data.css('table tbody tr').map do |x|
      { key: x.children[0].css('span')[0].text, value: x.children[1].text }
    end
    render status: :ok, json: array
  end
end
