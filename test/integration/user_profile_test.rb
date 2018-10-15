require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
    @other_user = users(:other_user)
  end
  test "activated user" do
    log_in_as @user
    get user_path(@other_user)
    assert_select ".user_info", text: @other_user.name
  end

  test "inactivated user" do
    log_in_as @user
    @other_user.update_attribute(:activated, false)
    get user_path(@other_user)
    assert_redirected_to root_path
  end
end
