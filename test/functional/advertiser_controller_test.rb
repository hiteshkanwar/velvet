require 'test_helper'

class AdvertiserControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get confirm" do
    get :confirm
    assert_response :success
  end

end
