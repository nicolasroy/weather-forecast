module OpenWeatherMap
  class CurrentWeatherResponse < Response
    def area
      Area.new(
        name: body["name"],
        latitude: body.dig(*%w[coord lat]),
        longitude: body.dig(*%w[coord lon]),
      )
    end

    def current_condition
      CurrentCondition.new(
          temperature: body.dig(*%w[main temp]),
          feels_like: body.dig(*%w[main feels_like]),
          high: body.dig(*%w[main temp_max]),
          low:  body.dig(*%w[main temp_min]),
        )
    end
  end
end
