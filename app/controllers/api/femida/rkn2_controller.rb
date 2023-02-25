# frozen_string_literal: true

class Api::Femida::Rkn2Controller < ApplicationController
  protect_from_forgery with: :null_session

  api :GET, '/rkn/:id', 'Реестр лицензий в области связи'
  def show
    'https://rkn.gov.ru/opendata/7705846236-LicComm/data-20230208T0000-structure-20220708T0000.zip'

    render status: :ok, json: { sro: Sro.count, members: SroMember.count, kind: SroKind.count, time: Time.current - time }
  end

  private

  def load_file
    path = Tempfile.new(['temp_sro', '.xlsx']).path
    File.binwrite(path, RestClient.get('https://cbr.ru/vfs/finmarkets/files/supervision/list_sro.xlsx'))
    path
  end
end
