class GeocodeController < ApplicationController
  def new
  end

  def create
    if us_zip_code?
      redirect_to zip_path(geocode_params[:zip_code])
    else
      flash[:error] = "Only US addresses are currently supported."

      render :new, status: :unprocessable_entity
    end
  end

  private

  def geocode_params
    params.permit(:zip_code, :country_code, :authenticity_token)
  end

  def us_zip_code?
    geocode_params[:country_code] == "US" && geocode_params[:zip_code].present?
  end
end
