# frozen_string_literal: true

class Api::Femida::RknController < ApplicationController
  protect_from_forgery with: :null_session

  SIZE = 30_000
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

  api :GET, '/rkn', 'Роскомнадзор'
  def index
    URLS.each do |key, value|
      url = URL + value
      filename = get_filename(url)

      rkn = Rkn.find_by(number: key, deleted_at: nil)
      if rkn && rkn.filename == filename
      else
        rkn.deleted_at = Time.current if rkn
        Rkn.create(number: key, status: :new, filename: filename)
      end
    end
    render status: :ok, json: Rkn.where(deleted_at: nil).all.to_json
  end

  api :GET, '/rkn/:id', 'Роскомнадзор'
  def show
    render status: :not_found, json: { status: :not_found } and return if URLS[params[:id]].nil?

    size = 0
    time = Time.now
    @klass = "Rkn#{params[:id]}".constantize
    @rkn = @klass.new
    url = URL + URLS[params[:id]]
    rkn = Rkn.find_by(number: params[:id], deleted_at: nil)
    render status: :ok, json: { status: :already_finished } and return if rkn.status == 'finished'

    filename = rkn.filename || get_filename(url)
    rkn.update(status: :started)
    case filename.split('.').last
    when 'xml'
      size = parse(RestClient.get(url + '/' + filename), stream: false)
    when 'zip'
      path = Tempfile.new(['file', '.zip']).path
      File.binwrite(path, RestClient.get(url + '/' + filename))
      Zip::File.open(path) do |zip_file|
        size = zip_file.sum { |entry| params[:id] == '6' ? parse_by_line(entry) : parse(entry) }
      end
    else
      size
    end
    rkn.update(status: :finished, rows: size)

    render status: :ok, json: { time: (Time.now - time), size: size }
  end

  private

  def get_filename(url)
    parsed_data = Nokogiri::HTML.parse(RestClient.get(url))
    list = parsed_data.css('table.TblList tr')[1..].map { |x| { key: x.children[3].text, value: x.children[5].text } }
    list.find { |x| x[:key] == 'Гиперссылка (URL) на набор' }[:value]
  end

  def parse(entry, stream: true)
    array = []
    Nokogiri::XML.parse(stream ? entry.get_input_stream.read : entry)
                 .xpath("//rkn:register/rkn:#{params[:id] == '18' ? 'expert' : 'record'}").each do |x|
      hash = @rkn.attributes.to_h
      hash.delete('id')
      x.children.each { |ch| hash[ch.name] = ch.text.chomp if @rkn.attribute_names.include?(ch.name) }
      array << hash
    end
    insert(array)
    array.size
  end

  def parse_by_line(entry)
    array = []
    size = 0
    entry.get_input_stream.each("</rkn:record>") do |raw_line|
      record = "<rkn:record>" + raw_line.split("<rkn:record>").last.delete("\r\n\t")
      hash = @rkn.attributes.to_h
      hash.delete('id')
      Nokogiri::XML.parse(record).children[0].children.each do |ch|
        name = ch.name.split(':').last
        hash[name] = ch.text.chomp if @rkn.attribute_names.include?(name)
      end
      array << hash
      if array.size == SIZE
        insert(array)
        array = []
        size += 1
      end
    end
    size * SIZE + array.size
  end

  def insert(array)
    array.each_slice(SIZE) { |slice| @klass.insert_all(slice) }
  end
end
