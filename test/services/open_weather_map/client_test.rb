require "test_helper"

class OpenWeatherMap::ClientTest < ActiveSupport::TestCase
  SUCCESS_RESPONSE = { status: 200, headers: { "Content-Type" => "application/json" } }

  context "current_weather" do
    should "return a success response" do
      stub_open_weather_map_current_weather("94040")

      response = OpenWeatherMap::Client.current_weather("94040")

      assert_predicate response, :success?
      assert_equal "Mountain View", response.body["name"]
    end

    should "Handle api error response" do
      stub_open_weather_map_current_weather("94040", response: {
        status: 500,
        headers: {},
        body: ""
      })

      response = OpenWeatherMap::Client.current_weather("94040")

      assert_not_predicate response, :success?
      assert_empty response.error_message
    end

    should "Handle errors in the response body" do
      stub_open_weather_map_current_weather("94040", response: {
        body: { cod: 400, message: "Invalid zip code" }.to_json
      })

      response = OpenWeatherMap::Client.current_weather("94040")

      assert_not_predicate response, :success?
      assert_equal "Invalid zip code", response.error_message
    end
  end

  context "one_call" do
    setup do
      @latitude = 37.7749
      @longitude = -122.4194
    end

    should "return a success response" do
      stub_open_weather_map_one_call(@latitude, @longitude)

      response = OpenWeatherMap::Client.one_call(@latitude, @longitude)

      assert_predicate response, :success?
    end

    should "handle api error response" do
      stub_open_weather_map_one_call(@latitude, @longitude, response: {
        status: 500,
        headers: {},
        body: ""
      })

      response = OpenWeatherMap::Client.one_call(@latitude, @longitude)

      assert_not_predicate response, :success?
      assert_empty response.error_message
    end

    should "Handle errors in the response body" do
      stub_open_weather_map_one_call(@latitude, @longitude, response: {
        body: { cod: 400, message: "Invalid latitude or longitude" }.to_json
      })

      response = OpenWeatherMap::Client.one_call(@latitude, @longitude)

      assert_not_predicate response, :success?
      assert_equal "Invalid latitude or longitude", response.error_message
    end
  end
end
