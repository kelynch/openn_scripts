#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'pry'


collection_json = File.read('manifest.json')
collection_manifest = JSON.parse(collection_json)

collection_manifest['manifests'].each do |manifest|
  ark = ''
  uri = URI(manifest['@id'])
  response = Net::HTTP.get(uri)
  object_manifest = JSON.parse(response)

  object_manifest['metadata'].each do |md|
    binding.pry
  end
end
