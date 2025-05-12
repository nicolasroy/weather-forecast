require "test_helper"

class GeocodeControllerTest < ActionDispatch::IntegrationTest
  context "GET #new" do
    should "render new" do
      get new_geocode_path
      assert_response :success
    end
  end

  context "POST #create" do
    should "redirect to the zip code resource for US addresses" do
      post geocode_path, params: { zip_code: "12345", country_code: "US" }

      assert_redirected_to zip_path(12345)
    end
  end
end
