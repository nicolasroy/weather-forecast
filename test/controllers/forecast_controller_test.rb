require "test_helper"

class ForecastControllerTest < ActionDispatch::IntegrationTest
  setup do
    @latitude = 37.7749
    @longitude = -122.4194
  end

  should "get show" do
    stub_open_weather_map_one_call(@latitude, @longitude)

    get forecast_url(latitude: @latitude, longitude: @longitude)

    assert_response :success
  end

  should "reload the page when the API returns retryable error" do
    stub_open_weather_map_one_call(@latitude, @longitude, response: {
      status: 500,
      headers: {},
      body: ""
    })

    get forecast_url(latitude: @latitude, longitude: @longitude)

    assert_redirected_to forecast_url(latitude: @latitude, longitude: @longitude, attempt: 1)
  end

  should "render the error page on the third retry attempt" do
    stub_open_weather_map_one_call(@latitude, @longitude, response: {
      status: 500,
      headers: {},
      body: ""
    })

    get forecast_url(latitude: @latitude, longitude: @longitude, attempt: 2)

    assert_response :unprocessable_entity
    assert_match "An error occurred", @response.body
  end
end
