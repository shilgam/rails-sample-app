require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
  end

  test "login form renders properly" do
    get login_path
    assert_select 'form[action="/login"]'
    assert_template 'sessions/new'
  end

  test "login with invalid info" do
    get login_path
    post login_path, params: { session: {
      email: "user@invalid",
      password: "invalid"
    } }
    assert_template 'sessions/new'
    assert_not flash[:danger].empty?

    get home_path
    assert flash.empty?
  end

  test "login with valid info followed by logout" do
    get login_path
    log_in_as @user
    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_url

    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns[:user].remember_token
  end

  test "login without remembering" do
    # Log in to set the cookie
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
