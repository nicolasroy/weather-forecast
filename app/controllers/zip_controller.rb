class ZipController < ApplicationController
  def show
    response = OpenWeatherMap::Client.current_weather(params[:code])
    if response.success?
      @area = response.area
      @current_condition = response.current_condition
    else
      render :error, status: :unprocessable_entity
    end
  end
end
