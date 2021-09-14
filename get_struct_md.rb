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
range_values = Hash.new

workbook = RubyXL::Parser.parse("pages.xlsx")
worksheet = workbook[0]

range_ids = object_manifest['structures'].first['ranges']
range_ids.each do |range_id|
  range = object_manifest['structures'].select {|rid| rid["@id"] == range_id }.first
  canvas_id = range["canvases"].first
  range_values[canvas_id] = range["label"]
end

object_manifest['sequences'].each do |seq|
  seq['canvases'].each do |canvas|
    tag_1 = ''
    value_1 = ''
    serial_num += 1
    label = canvas['label']
    tiff_url = canvas['rendering'].first['@id']

    puts "Handling #{tiff_url}"

    sleep (5)

    h = client.head(tiff_url).header
    filename_response = h['Content-Disposition']
    filename = /[0-9]+.tif/.match(filename_response.first).to_s

    if range_values.keys.include?(canvas["@id"])
      tag_1 = "TOC_ENTRY"
      value_1 = range_values[canvas["@id"]]
    end

    csv_data << [serial_num, label,  filename, tag_1, value_1, tiff_url]
  end
end

spreadsheet_offset = 3

csv_data.each_with_index do |value, index|
  serial_num_y_index = 0
  display_page_y_index = 1
  file_name_y_index = 2
  tag_1_y_index = 3
  value_1_y_index = 4
  url_y_index = 15
  worksheet.add_cell((spreadsheet_offset+index), serial_num_y_index, value[0])
  worksheet.add_cell((spreadsheet_offset+index), display_page_y_index, value[1])
  worksheet.add_cell((spreadsheet_offset+index), file_name_y_index, value[2])
  worksheet.add_cell((spreadsheet_offset+index), tag_1_y_index, value[3])
  worksheet.add_cell((spreadsheet_offset+index), value_1_y_index, value[4])
  worksheet.add_cell((spreadsheet_offset+index), url_y_index, value[5])
end

workbook.write("#{manifest_filename}.xlsx")
