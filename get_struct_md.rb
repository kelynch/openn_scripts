#!/usr/bin/env ruby

require 'csv'
require 'net/http'
require 'json'
require 'pry'
require 'httpclient'
require 'rubyXL'

manifest_filename = ARGV[0]
object_json = File.read(manifest_filename)
object_manifest = JSON.parse(object_json)
client = HTTPClient.new
serial_num = 0

csv_data = []

workbook = RubyXL::Parser.parse("pages.xlsx")
worksheet = workbook[0]

object_manifest['sequences'].each do |seq|
  seq['canvases'].each do |canvas|
    serial_num += 1
    label = canvas['label']
    tiff_url = canvas['rendering'].first['@id']
    h = client.head(tiff_url).header
    filename_response = h['Content-Disposition']
    filename = /[0-9]+.tif/.match(filename_response.first).to_s
    csv_data << [serial_num, label, filename, tiff_url]
  end
end

spreadsheet_offset = 3

csv_data.each_with_index do |value, index|
  serial_num_y_index = 0
  display_page_y_index = 1
  file_name_y_index = 2
  url_y_index = 15
  worksheet.add_cell((spreadsheet_offset+index), serial_num_y_index, value[0])
  worksheet.add_cell((spreadsheet_offset+index), display_page_y_index, value[1])
  worksheet.add_cell((spreadsheet_offset+index), file_name_y_index, value[2])
  worksheet.add_cell((spreadsheet_offset+index), url_y_index, value[3])
end

workbook.write("#{manifest_filename}.xlsx")
