#!/usr/bin/env ruby

require 'csv'
require 'net/http'
require 'json'
require 'pry'
require 'httpclient'

object_json = File.read(ARGV[0])
object_manifest = JSON.parse(object_json)
client = HTTPClient.new
serial_num = 0

csv_data = []
csv_data << ["SERIAL_NUM", "DISPLAY PAGE", "FILE_NAME"]

object_manifest['sequences'].each do |seq|
  seq['canvases'].each do |canvas|
    serial_num += 1
    label = canvas['label']
    tiff_url = canvas['rendering'].first['@id']
    h = client.head(tiff_url).header
    filename_response = h['Content-Disposition']
    filename = /[0-9]+.tif/.match(filename_response.first).to_s
    csv_data << [serial_num, label, filename]
  end
end

File.write("#{ARGV[1]}.csv", csv_data.map(&:to_csv).join)
