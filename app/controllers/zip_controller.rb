class ZipController < ApplicationController
  def show
    @response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?zip=#{params[:code]},us&appid=#{Rails.application.credentials.openweathermap.api_key}")
    if @response.success?
      payload = @response.parsed_response.with_indifferent_access
      @area = ZipArea.new(
        code: params[:code],
        name: payload.dig(:name),
        latitude: payload.dig(:coord, :lat),
        longitude: payload.dig(:coord, :lon),
      )
      @current_condition = CurrentCondition.new(
        zip_code: params[:code],
        temperature: payload.dig(:main, :temp),
        feels_like: payload.dig(:main, :feels_like),
        high: payload.dig(:main, :temp_max),
        low:  payload.dig(:main, :temp_min),
      )
    else
      render :error, status: :unprocessable_entity
    end
  end
end
