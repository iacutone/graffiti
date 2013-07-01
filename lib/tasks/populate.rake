#require "#{Rails.root}/app/helpers/application_helper"
#include ApplicationHelper

task :insert_platt101 => :environment do
  @restaurants = File.readlines('./data/masterlist.txt')
  @restaurants.each do |string|
    period = string.index(".")
    star = string.index('*')
    rank_old = string.index(/\(\d*\)/)

    begin
      string = string.insert(period+1, ",")
      string = string.insert(star, ",")
      string = string.insert(rank_old, ",")
    rescue
      next

    end
    array = string.split(',')
    @restaurant = Restaurant.new
    @restaurant.rank = array[0]
    @restaurant.name = array[1].lstrip!
    @restaurant.stars = array[2]
    @restaurant.nymag_page = array[1].gsub(" ", '-').downcase
    @restaurant.save
  end
end

task :parse_rank_old => :environment do
  @restaurants = Restaurant.all
  @restaurants.each do |string|
    begin
    rank_old = string.name.index(/\(\d*\)/)
    temp_string = string.name.insert(rank_old, ",")
    array = temp_string.split(',')
    string.name = array[0].strip
    puts string.name
    string.rank_old = array[1].gsub("(","").gsub(")","")
    puts string.rank_old
    string.nymag_page = string.name.gsub(" ", '-').downcase
    string.save
    rescue
    next
    end
  end

end




task :insert_yelpid => :environment do
    @restaurants = Restaurant.all
    client = Yelp::Client.new
    @restaurants.each do |r|
      request = Yelp::V2::Search::Request::Location.new(
        :term => r.name,
        :city => 'New York', 
        :state => 'NY',
        :limit => '1',
        :consumer_key => ENV["YELP_KEY"], 
        :consumer_secret => ENV["YELP_SECRET"], 
        :token => ENV["YELP_TOKEN"], 
        :token_secret => ENV["YELP_TOKEN_SECRET"])
      response = client.search(request)
      r.yelp_id = response["businesses"][0]["id"]
      r.yelp_image_url = response["businesses"][0]["image_url"]
      r.yelp_url = response["businesses"][0]["url"]
      r.yelp_phone = response["businesses"][0]["phone"]
      r.yelp_display_phone = response["businesses"][0]["display_phone"]
      r.yelp_review_count = response["businesses"][0]["review_count"]
      r.yelp_categories = response["businesses"][0]["categories"]
      r.yelp_rating = response["businesses"][0]["rating"]
      r.yelp_rating_img_url = response["businesses"][0]["rating_img_url"]
      r.yelp_rating_img_url_small = response["businesses"][0]["rating_img_url_small"]
      r.yelp_rating_img_url_large = response["businesses"][0]["rating_img_url_large"]
      r.yelp_snippet_text = response["businesses"][0]["snippet_text"]
      r.yelp_location = response["businesses"][0]["location"]
      r.yelp_location_coordinate = response["businesses"][0]["location"]["coordinate"]
      r.yelp_location_coordinate_latitude = response["businesses"][0]["location"]["coordinate"]["latitude"]
      r.yelp_location_coordinate_longitude = response["businesses"][0]["location"]["coordinate"]["longitude"]
      r.yelp_location_address = response["businesses"][0]["location"]["address"][0]
      r.yelp_location_display_address = response["businesses"][0]["location"]["display_address"]
      r.yelp_location_city = response["businesses"][0]["location"]["city"]
      r.yelp_location_state_code = response["businesses"][0]["location"]["state_code"]
      r.yelp_location_postal_code = response["businesses"][0]["location"]["postal_code"]
      r.yelp_location_country_code = response["businesses"][0]["location"]["country_code"]
      r.yelp_location_cross_streets = response["businesses"][0]["location"]["cross_streets"]
      r.yelp_location_neighborhoods = response["businesses"][0]["location"]["neighborhoods"]
      r.yelp_location_geo_accuracy = response["businesses"][0]["location"]["geo_accuracy"]
      r.yelp_deals = response["businesses"][0]["yelp_deals"]
      puts r.yelp_phone
      r.save
      #broadcast "/messages/new" do
      #  $("#Yelp_Reviews").replaceWith(<h2 id="Yelp_Reviews">"Yelp Review Count: <%= :yelp_review_count %></h2>");
      #end
    end
end

task :wash_hoods => :environment do
    
  @restaurants = Restaurant.all
  @restaurants.each do |r|
    begin
    r.yelp_location_neighborhoods = r.yelp_location_neighborhoods.gsub(/---\n- /, "")
    r.yelp_location_neighborhoods = r.yelp_location_neighborhoods.gsub(/\n- /, "-") 
    r.yelp_location_neighborhoods = r.yelp_location_neighborhoods.gsub(/\n/, "") 
    puts r.yelp_location_neighborhoods
    r.save
    rescue
      puts "couldnt gsub"
      next
    end  
  end
end

namespace :yipit_cron do
  task :yipit => :environment do
    client = Yipit::Client.new(ENV["YIPIT"])


    @restaurants = Restaurant.all
    @restaurants.each do |r|
      begin
        yipit_num = r.yelp_phone
        yipit_num.insert(+6,'-')
        yipit_num.insert(+3,'-')
        url = client.deals(:phone => yipit_num)
        
          if url.empty?
            r.yipit_url = "No deals today"
          else
            r.yipit_url = url[0]["url"]
            puts r.yipit_url
          end
        
        r.save
        rescue
         puts "No number."
          next
        end
      end
    end
  end

task :twitter_num => :environment do
  Twitter.configure do |config|
    config.consumer_key = ENV['TWITTER_KEY']
    config.consumer_secret = ENV['TWITTER_SECRET']
    config.oauth_token = ENV['TWITTER_OATH_TOKEN']
    config.oauth_token_secret = ENV['TWITTER_OATH_TOKEN_SECRET']
  end

  @restaurants = Restaurant.all
  @restaurants.each do |r|
      # r.tweets_num = 0 
      # r.tweets_last_id = 0
      @tweets = Twitter.search(r.name, :geocode => '40.768483,-73.981248,20mi', :since_id => r.tweets_last_id, :rpp => '100')
      @tweets = @tweets.to_hash
      @tweet = @tweets[:statuses]
      @tweet.each do |tweet|
        puts r.name
        r.tweets_num += 1
        puts r.tweets_num
        r.tweets_last_id = tweet[:id]
        puts r.tweets_last_id

        r.save
      end
  end
end

task :instagram_num => :environment do
  Instagram.configure do |config|
    config.client_id = ENV['INSTGRAM_ID']
    config.client_secret = ENV['INSTAGRAM_SECRET']
  end

  
end
