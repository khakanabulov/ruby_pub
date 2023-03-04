# frozen_string_literal: true

class Api::Femida::RknController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/rkn/:id', 'Реестр лицензий в области связи'
  def show
    resp = RestClient.get("https://rkn.gov.ru/opendata/#{params[:id]}-LicComm")
    parsed_data = Nokogiri::HTML.parse(resp)
    array = parsed_data.css('table.TblList tr')[1..].map do |x|
      { key: x.children[3].text, value: x.children[5].text }
    end
    render status: :ok, json: array
  end
end
