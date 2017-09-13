require 'test_helper'

class LobbyControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get lobby_home_url
    assert_response :success
  end

end
