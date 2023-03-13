# frozen_string_literal: true

class Api::Femida::RknController < ApplicationController
  protect_from_forgery with: :null_session

  SIZE = 30_000
  URL = 'https://rkn.gov.ru/opendata/7705846236-'
  URL2 = 'https://fsrar.gov.ru/opendata/7710747640-'
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
    '26' => 'NewsAgregator',
    'fsrar' => 'reestr'
  }.freeze

  api :GET, '/rkn', 'Роскомнадзор'
  def index
    URLS.each do |key, value|
      url = (key == 'fsrar' ? URL2 : URL) + value
      filename = get_filename(key, url)

      rkn = Rkn.find_by(number: key, deleted_at: nil)
      if rkn && rkn.filename == filename
      else
        rkn.deleted_at = Time.current if rkn
        rkn.save
        Rkn.create(number: key, status: :new, filename: filename)
      end
    end
    @rkn = Rkn.where(deleted_at: nil).all.order(id: :desc)
  end

  api :GET, '/rkn/:id', 'Роскомнадзор'
  def show
    render status: :not_found, json: { status: :not_found } and return if URLS[params[:id]].nil?

    size = 0
    time = Time.now
    @klass = "Rkn#{params[:id]}".constantize
    @rkn = @klass.new
    url = (params[:id] == 'fsrar' ? URL2 : URL) + URLS[params[:id]]
    rkn = Rkn.find_by(number: params[:id], deleted_at: nil)
    render status: :ok, json: { status: :already_finished } and return if rkn.status == 'finished'

    filename = rkn.filename || get_filename(params[:id], url)
    rkn.update(status: :started)
    case filename.split('.').last
    when 'xml'
      size = parse(RestClient.get(url + '/' + filename), stream: false)
    when 'zip'
      path = Tempfile.new(['file', '.zip']).path
      File.binwrite(path, RestClient.get(url + '/' + filename))
      Zip::File.open(path) do |zip_file|
        size = zip_file.sum do |entry|
          case params[:id]
          when '6' then parse_by_line(entry)
          when 'fsrar' then parse_by_line(entry, 'row')
          else parse(entry)
          end
      end
      end
    else
      size
    end
    rkn.update(status: :finished, rows: size)

    render status: :ok, json: { time: (Time.now - time), size: size }
  end

  private

  def get_filename(id, url)
    parsed_data = Nokogiri::HTML.parse(RestClient.get(url))
    list = if id == 'fsrar'
      parsed_data.css('table.sticky-enabled tr')[1..].map { |x| { key: x.children[0].text, value: x.children[1].text } }
    else
      parsed_data.css('table.TblList tr')[1..].map { |x| { key: x.children[3].text, value: x.children[5].text } }
    end
    list.find { |x| x[:key] == 'Гиперссылка (URL) на набор' }[:value].split("/").last
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

  def parse_by_line(entry, attr = 'rkn:record')
    array = []
    size = 0
    entry.get_input_stream.each("</#{attr}>") do |raw_line|
      record = "<#{attr}>" + raw_line.split("<#{attr}").last.delete("\r\n\t")
      hash = @rkn.attributes.to_h
      hash.delete('id')
      attrs = Nokogiri::XML.parse(record).children[0].children
      array << (attr == 'rkn:record' ? attrs_record(attrs, hash) : attrs_row(attrs, hash))
      if array.size == SIZE
        insert(array)
        array = []
        size += 1
      end
    end
    size * SIZE + array.size
  end

  def attrs_record(attrs, hash)
    attrs.each do |ch|
      name = ch.name.split(':').last
      hash[name] = ch.text.chomp if @rkn.attribute_names.include?(name)
    end
    hash
  end

  def attrs_row(attrs, hash)
    @rkn.attribute_names[1..].each_with_index { |name, index| hash.send :'[]=', name, attrs[index+1]&.text }
    hash
  end

  def insert(array)
    array.each_slice(SIZE) { |slice| @klass.insert_all(slice) }
  end
end
