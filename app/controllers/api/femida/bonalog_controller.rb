# frozen_string_literal: true

class Api::Femida::BonalogController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/bonalog?query=string', 'Проверка бух/фин отчетности- (https://bo.nalog.ru/)'
  def index
    json = JSON.parse RestClient.get("https://bo.nalog.ru/nbo/organizations/search?query=#{CGI.escape params[:query]}")
    render status: :ok, json: json['content']
  end
end
