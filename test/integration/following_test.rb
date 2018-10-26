require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
    log_in_as(@user)
  end

  test "the truth" do
    assert true
  end
end
