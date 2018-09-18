require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "signup with invalid info" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      } }
    end
    assert_template 'users/new'

    assert_select "#error_explanation" do
      assert_select 'li:nth-child(1)', "Name can't be blank"
      assert_select 'li:nth-child(2)', "Email is invalid"
      assert_select 'li:nth-child(3)', "Password confirmation doesn't match Password"
      assert_select 'li:nth-child(4)', "Password is too short (minimum is 6 characters)"
    end
  end

  test "Signup form renders properly" do
    get signup_path
    assert_select 'form[action="/signup"]'
  end

  test "signup with valid info" do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {
        name: "Valid User",
        email: "user@valid.com",
        password: "validpass",
        password_confirmation: "validpass"
      } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash[:success].nil?
    assert logged_in?
  end
end
