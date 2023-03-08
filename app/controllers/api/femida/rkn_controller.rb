# frozen_string_literal: true

class Api::Femida::RknController < ApplicationController
  protect_from_forgery with: :null_session
  URL = 'https://rkn.gov.ru/opendata/7705846236-'
  URLS = {
    '2' => 'LicComm',
    '3' => 'ResolutionSMI',
    '5' => 'SignificantTelecomOperators',
    '6' => 'OperatorsPD',
    '10' => 'BorderTelecommunications',
    '13' => 'InspectionPlan',
    '14' => 'AuditsResults',
    '18' => 'AccreditedExpertsMassCommunications',
    '20' => 'InformationDistributor',
    '26' => 'NewsAgregator'
  }.freeze

  api :GET, '/rkn/:id', 'Роскомнадзор'
  def show
    (render(status: :not_found, json: { status: :not_found }) and return) if URLS[params[:id]].nil?

    url = URL + URLS[params[:id]]
    resp = RestClient.get(url)
    parsed_data = Nokogiri::HTML.parse(resp)
    list = parsed_data.css('table.TblList tr')[1..].map do |x|
      { key: x.children[3].text, value: x.children[5].text }
    end
    filename = list.find { |x| x[:key] == 'Гиперссылка (URL) на набор' }[:value]
    if filename.split('.').last == 'xml'
      parse(RestClient.get(url + '/' + filename), stream: false)
    else
      path = Tempfile.new(['file', '.zip']).path
      File.binwrite(path, RestClient.get(url + '/' + filename))
      Zip::File.open(path) { |zip_file| zip_file.each { |entry| parse(entry) } }
    end
    render status: :ok, json: { list: list }
  end

  private

  def parse(file, stream: true)
    klass = "Rkn#{params[:id]}".constantize
    rkn = klass.new
    byebug
    z = Nokogiri::XML.parse(stream ? file.get_input_stream.read : file)
    array = z.xpath("//rkn:register/rkn:record").map do |x|
      hash = rkn.attributes.to_h
      hash.delete('id')
      x.children.each { |ch| hash[ch.name] = ch.text.chomp if rkn.attribute_names.include?(ch.name) }
      hash
    end
    array.each_slice(30_000) { |slice| klass.insert_all(slice) }
  end
end
