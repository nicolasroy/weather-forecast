class ZipController < ApplicationController
  def show
    attempt = params.fetch(:attempt, 0).to_i + 1

    @response = OpenWeatherMap::Client.current_weather(params[:code])
    if @response.success?
      @area = @response.area
      @current_condition = @response.current_condition

    elsif @response.retryable? && attempt < 3
      redirect_to zip_path(code: params[:code], attempt:)

    else
      render :error, status: :unprocessable_entity
    end
  end
end
