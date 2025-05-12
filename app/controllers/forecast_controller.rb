class ForecastController < ApplicationController
  def show
    attempt = params.fetch(:attempt, 0).to_i + 1

    @response = OpenWeatherMap::Client.one_call(params[:latitude], params[:longitude])

    if @response.success?
      @daily_forecasts = @response.daily_forecasts

    elsif @response.retryable? && attempt < 3
      redirect_to forecast_path(
        latitude: params[:latitude],
        longitude: params[:longitude],
        attempt:
      )

    else
      render :error, status: :unprocessable_entity
    end
  end
end
