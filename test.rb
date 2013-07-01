require 'httparty'
require 'json'
require 'pry'


response = HTTParty.get('http://data.cityofnewyork.us/resource/2j99-6h29.json')

hash = {}
# array = []
# response.each do |item|
# 	array << item['created_date']
# 	array << item['closed_date']
# 	array << item['resolution_action']
# 	array << item['status']
# 	array << item['incident_address_display']
# 	array << item['borough']
# 	array << item['y_coordinate']
# 	array << item['x_coordinate']
# 	binding.pry
# end
