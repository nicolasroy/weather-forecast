require "ostruct"

module OpenWeatherMap
  class Client
    BASE_URL = "https://api.openweathermap.org"
    Error = Class.new(Faraday::Error)

    class << self
      def current_weather(zip_code)
        response = connection.get("/data/2.5/weather", zip: "#{zip_code},us")
        CurrentWeatherResponse.new(**response.to_hash)
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
        CurrentWeatherResponse.new(body: e.message, response_headers: { "Retry-After" => 0 })
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
end
