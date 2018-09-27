require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
    @other_user = users(:other_user)
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
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
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    assert_redirected_to root_url
  end

  test "the admin attribute is not editable through the web" do
    log_in_as(@user)
    new_name = 'New Username'

    patch user_path(@user), params: { user: {
      name: new_name,
      email: @user.email,
      admin: true
    } }
    @user.reload
    assert_equal new_name, @user.name
    assert_equal false, @user.admin
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as @user
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to root_path
  end
end
