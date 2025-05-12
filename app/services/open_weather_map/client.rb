require "ostruct"

module OpenWeatherMap
  class Client
    BASE_URL = "https://api.openweathermap.org"

    class << self
      def current_weather(zip_code)
        request(CurrentWeatherResponse, "/data/2.5/weather", zip: "#{zip_code},us")
      end

      def one_call(latitude, longitude)
        exclusions = %w[current minutely hourly alerts]

        request(OneCallResponse, "/data/3.0/onecall", lat: latitude, lon: longitude, exclude: exclusions.join(","))
      end

      private

      def request(response_class, endpoint, params)
        response = connection.get(endpoint, params)
        response_class.new(**response.to_hash)
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
        response_class.new(body: e.message, response_headers: { "Retry-After" => 0 })
      end

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
