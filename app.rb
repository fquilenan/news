require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here



ForecastIO.api_key = "53a022d82a10fe7eda6573c19005e78a"
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=35f49f42cf68412f95e1e2dd7fbdb17b"
news = HTTParty.get(url).parsed_response.to_hash
# news is now a Hash you can pretty print (pp) and parse for your output
 


get "/" do
  # show a view that asks for the location
  view "ask"
end


get "/news" do
    @location = params["location"]
  results = Geocoder.search(params["location"])
    lat_lng = results.first.coordinates
    @lat = lat_lng[0]
    @lng = lat_lng[1]
    @forecast = ForecastIO.forecast(@lat,@lng).to_hash
    @current_temperature = @forecast["currently"]["temperature"]
    @current_conditions = @forecast["currently"]["summary"]
    @daily_forecast = @forecast["daily"]["data"]
  view "news"

  # do everything else
end