require "ostruct"

module OpenWeatherMap
  class Client
    BASE_URL = "https://api.openweathermap.org"

    class << self
      def current_weather(zip_code)
        cached_request(CurrentWeatherResponse, "/data/2.5/weather", zip: "#{zip_code},us")
      end

      def one_call(latitude, longitude)
        exclusions = %w[current minutely hourly alerts]
        cached_request(OneCallResponse, "/data/3.0/onecall", lat: latitude, lon: longitude, exclude: exclusions.join(","))
      end

      def api_key
        return "test" if Rails.env.test?

        Rails.application.credentials.openweathermap.api_key
      end

      private

      # TODO: make the Response class know it came from cache
      def cached_request(response_class, endpoint, params)
        cache_key = params.values.join(",")

        cached_response = Rails.cache.read(cache_key)
        return cached_response if cached_response

        response = request(response_class, endpoint, params)
        response.cached_on = Time.now
        Rails.logger.info("Caching response for #{cache_key} with #{response.inspect}")
        Rails.cache.write(cache_key, response, expires_in: 30.minutes) unless response.failure? && response.retryable?

        response
      end

      def request(response_class, endpoint, params)
        response = connection.get(endpoint, params)
        response_class.new(**response.to_hash)
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
        response_class.new(body: e.message, response_headers: { "Retry-After" => 0 })
      end

      def connection
        Faraday.new(url: BASE_URL, params: { appid: api_key }) do |f|
          f.request :json
          f.response :json
        end
      end
    end
  end
end
