require "ostruct"

class OpenWeatherMap::Client
  BASE_URL = "https://api.openweathermap.org"

  class << self
    def current_weather(zip_code)
      response = connection.get("/data/2.5/weather", zip: "#{zip_code},us")
      OpenWeatherMap::CurrentWeatherResponse.new(response)
    end

    private

    def connection
      api_key = Rails.application.credentials.openweathermap.api_key
      Faraday.new(url: BASE_URL, params: { appid: api_key }) do |f|
        f.request :json
        f.response :json
      end
    end
  end
end
