#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'pry'

manifest = ARGV[0]

puts "Parsing #{ARGV[0]}"

collection_json = File.read(manifest)
collection_manifest = JSON.parse(collection_json)

collection_manifest['manifests'].each do |manifest|
  ark = ''
  uri = URI(manifest['@id'])
  response = Net::HTTP.get(uri)
  object_manifest = JSON.parse(response)

  object_manifest['metadata'].each do |md|
    if md['label'] == "Identifier"
      html_value = md['value'].first
      ark = URI.extract(html_value).last.gsub("http://arks.princeton.edu/","")
    end
  end
  puts "#{ark}"
end
