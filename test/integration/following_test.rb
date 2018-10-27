require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
    log_in_as(@user)
  end

  test "follow button" do
    @unknown = users(:guest)
    get user_path(@unknown)
    assert_select '#follow_form .btn[value=?]', "Follow"
  end

  test "unfollow button" do
    @star = users(:superstar)
    get user_path(@star)
    assert_select '#follow_form .btn[value=?]', "Unfollow"
  end

  test "follow / unfollow buttons if current user" do
    get user_path(@user)
    assert_select '#follow_form', count: 0
  end
end
