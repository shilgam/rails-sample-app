require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "Login form renders properly" do
    get login_path
    assert_select 'form[action="/login"]'
    assert_template 'sessions/new'
  end

  test "invalid login" do
    get login_path
    post login_path, params: { session: {
      email: "user@invalid",
      password: "invalid"
    } }
    assert_template 'sessions/new'
    assert_not flash[:danger].empty?
  end
end
