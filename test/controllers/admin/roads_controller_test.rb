require "test_helper"

class Admin::RoadsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_roads_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_roads_show_url
    assert_response :success
  end
end
