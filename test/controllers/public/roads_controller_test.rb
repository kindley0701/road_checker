require "test_helper"

class Public::RoadsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_roads_show_url
    assert_response :success
  end
end
