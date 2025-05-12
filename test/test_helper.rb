ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def fixture_file(path)
      Rails.root.join("test/fixtures/files", path).read
    end

    def stub_open_weather_map_current_weather(zip_code, response: {})
      default_response = {
        status: 200,
        headers: { "Content-Type" => "application/json" },
        body: fixture_file("open_weather_map/current_weather_response.json")
      }

      stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=#{Rails.application.credentials.openweathermap.api_key}&zip=#{zip_code},us").
        to_return(default_response.merge(response))
    end
  end
end
