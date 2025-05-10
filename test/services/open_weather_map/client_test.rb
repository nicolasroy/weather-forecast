require "test_helper"

class OpenWeatherMap::ClientTest < ActiveSupport::TestCase
  SUCCESS_RESPONSE = { status: 200, headers: { "Content-Type" => "application/json" } }

  context "current_weather" do
    should "return a success response" do
      stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=#{Rails.application.credentials.openweathermap.api_key}&zip=94040,us").
        to_return(SUCCESS_RESPONSE.merge(body: fixture_file("open_weather_map/current_weather_response.json")))

      response = OpenWeatherMap::Client.current_weather("94040")

      assert_predicate response, :success?
      assert_equal "Mountain View", response.body["name"]
    end

    should "Handle api error response" do
      stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=#{Rails.application.credentials.openweathermap.api_key}&zip=94040,us").
        to_return(status: 500)

      response = OpenWeatherMap::Client.current_weather("94040")

      assert_not_predicate response, :success?
      assert_empty response.error_message
    end

    should "Handle errors in the response body" do
      stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=#{Rails.application.credentials.openweathermap.api_key}&zip=94040,us").
        to_return(SUCCESS_RESPONSE.merge(body: { cod: 400, message: "Invalid zip code" }.to_json))

      response = OpenWeatherMap::Client.current_weather("94040")

      assert_not_predicate response, :success?
      assert_equal "Invalid zip code", response.error_message
    end
  end
end
