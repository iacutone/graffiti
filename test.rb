require 'httparty'
require 'json'
require 'pry'

response = HTTParty.get('http://data.cityofnewyork.us/resource/2j99-6h29.json')
  	content = response.body
  	json_content = JSON.parse(content)
  	json_content.each do |item|
  		 # created_date = item["created_date"]
  		 # closed_date = item["closed_date"]
  		 # resolution_action = item["resolution_action"]
  		 # status = item["status"]
  		 # incident_address_display = item["incident_address_display"]
  		 borough = item["borough"]
  		 # x_coordinate = item["x_coordinate"]
  		 # y_coordinate = item[":y_coordinate"]

  		 s = Location.new(borough: borough)
  		 s.save
  		end