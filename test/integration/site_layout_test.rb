require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "layout links when logged out" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, text: "sample app"
    assert_select "a[href=?]", root_path, text: "Home"
    assert_select "a[href=?]", help_path, text: "Help"
    assert_select "a[href=?]", login_path, text: "Log in"
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", about_path, text: "About"
    assert_select "a[href=?]", contact_path, text: "Contact"
    assert_select "a[href=?]", signup_path, text: "Sign up now!"

    get contact_path
    assert_select "title", full_title("Contact")

    get signup_path
    assert_select "title", full_title("Sign up")
  end

  test "layout links when logged in" do
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", users_path, text: 'Users'
    assert_select "a[href=?]", user_path(@user), text: 'Profile'
    assert_select "a[href=?]", edit_user_path(@user), text: 'Settings'
  end
end
