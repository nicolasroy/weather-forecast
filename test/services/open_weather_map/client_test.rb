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
end
