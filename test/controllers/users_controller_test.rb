require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_redirected_to root_url
    # assert_select flash[:danger], "You do not have an access to this page."
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    assert_redirected_to root_url
    # assert_select flash[:danger], "You do not have an access to this page."
  end
end
