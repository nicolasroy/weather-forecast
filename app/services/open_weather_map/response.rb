class OpenWeatherMap::Response
  attr_reader :response

  def initialize(response)
    @response = response
  end

  def success?
    response.status == 200 && response.body["cod"] == 200
  end

  def error_message
    return body["message"] if body.is_a?(Hash)

    body
  end

  def body
    response.body
  end
end
