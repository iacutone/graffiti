class GraffitiWorker
  include Sidekiq::Worker

  def perform

  	response = HTTParty.get('http://data.cityofnewyork.us/resource/2j99-6h29.json')
  	content = response.body
  	json_content = JSON.parse(content)
  	json_content.each do |item|
  		 created_date = item["created_date"]
  		 # closed_date = item["closed_date"]
  		 # resolution_action = item["resolution_action"]
  		 # status = ["status"]
  		 # incident_address_display = ["incident_address_display"]
  		 # borough = ["borough"]
  		 # x_coordinate = ["x_coordinate"]
  		 # y_coordinate = [":y_coordinate"]

  		 s = Location.new(created_date: created_date)
  		 s.save
  	end
  end
end

, closed_date: closed_date,
  		 			resolution_action: resolution_action, status: status, incident_address_display: incident_address_display,
  		 			borough: borough, x_coordinate: x_coordinate, y_coordinate: y_coordinate