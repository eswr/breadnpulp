require 'test_helper'

class OtpsControllerTest < ActionController::TestCase
  test "should get activation" do
    get :activation
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

end
