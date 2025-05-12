module OpenWeatherMap
  class Response
    attr_reader :status, :response_headers, :body, :url

    def initialize(status: nil, response_headers: {}, body: nil, url: nil)
      @status = status
      @response_headers = response_headers
      @body = body
      @url = url
    end

    def success?
      status == 200 && (body.fetch("cod", 200) == 200)
    end

    def retryable?
      status.to_s.start_with?("5") || retry_after.present?
    end

    def retry_after
      response_headers["Retry-After"]&.to_i
    end


    def error_message
      return body["message"] if body.is_a?(Hash)

      body
    end
  end
end
