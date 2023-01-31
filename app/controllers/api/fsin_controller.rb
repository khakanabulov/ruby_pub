# frozen_string_literal: true

class Api::FsinController < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/fsin/:fio', 'Проверка ФСИН (РОЗЫСК) - json array: [{"fio": "", "dt": ""}] (https://limited.fsin.gov.ru/criminal/)'
  def show
    render status: :ok, json: FsinService.new(params[:id]).call
  end
end
