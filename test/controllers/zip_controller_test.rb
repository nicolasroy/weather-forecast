require "test_helper"

class ZipControllerTest < ActionDispatch::IntegrationTest
  context "GET #show" do
    should "render the show page" do
      stub_open_weather_map_current_weather("94040")

      get zip_path(code: "94040")

      assert_response :success
    end

    should "reload the page when the API returns retryable error" do
      stub_open_weather_map_current_weather("94040", response: {
        status: 500,
        headers: {},
        body: ""
      })

      get zip_path(code: "94040")

      assert_redirected_to zip_path(code: "94040", attempt: 1)
    end

    should "render the error page on the third retry attempt" do
      stub_open_weather_map_current_weather("94040", response: {
        status: 500,
        headers: {},
        body: ""
      })

      get zip_path(code: "94040", attempt: 2)
      assert_response :unprocessable_entity
      assert_match "An error occurred", @response.body
    end

    should "render the error page when the zip code is invalid" do
      stub_open_weather_map_current_weather("invalid", response: {
        status: 404,
        headers: {},
        body: { cod: "404", message: "city not found" }.to_json
      })

      get zip_path(code: "invalid")

      assert_response :unprocessable_entity
      assert_match "city not found", @response.body
    end
  end
end
