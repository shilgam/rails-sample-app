require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "signup form renders properly" do
    get signup_path
    assert_select 'form[action="/signup"]'
  end

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

  test "activate account and signup with valid info" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {
        name: "Valid User",
        email: "user@valid.com",
        password: "validpass",
        password_confirmation: "validpass"
      } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    assert_equal flash[:info], "Please check your email to activate your account."

    # Try to log in before activation
    log_in_as(user)
    assert_not logged_in? # TODO: User can login without activation. Fix it

    # Invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not logged_in?
    follow_redirect!
    assert_equal flash[:danger], "Invalid activation link"

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, 'wrong')
    assert_not logged_in?

    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert_equal flash[:success], "Account activated!"
    assert logged_in?
  end
end
