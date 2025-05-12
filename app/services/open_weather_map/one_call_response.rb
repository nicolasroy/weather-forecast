module OpenWeatherMap
  class OneCallResponse < Response
    def daily_forecasts
      body.dig("daily").map do |day|
        DailyForecast.new(
          date: Time.at(day.dig("dt")).to_date,
          temperature: day.dig("temp", "day"),
          feels_like: day.dig("feels_like", "day"),
          high: day.dig("temp", "max"),
          low: day.dig("temp", "min"),
        )
      end
    end
  end
end
