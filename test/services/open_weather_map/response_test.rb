require "test_helper"

module OpenWeatherMap
  class ResponseTest < ActiveSupport::TestCase
    context "recent?" do
      should "return true when response is less than 5 seconds old" do
        response = OpenWeatherMap::Response.new(cached_on: 1.seconds.ago)

        assert_predicate response, :recent?
      end

      should "return false when response is more than 5 seconds old" do
        response = OpenWeatherMap::Response.new(cached_on: 6.seconds.ago)

        assert_not_predicate response, :recent?
      end
    end

    context "retryable?" do
      should "return true when the server returns a 5xx status code" do
        response = OpenWeatherMap::Response.new(status: 500)

        assert_predicate response, :retryable?
      end

      should "return true when a Retry-After header is present" do
        response = OpenWeatherMap::Response.new(response_headers: { "Retry-After" => 1 })

        assert_predicate response, :retryable?
      end

      should "return false when the server response is successful" do
        response = OpenWeatherMap::Response.new(status: 200)

        assert_not_predicate response, :retryable?
      end
    end
  end
end
