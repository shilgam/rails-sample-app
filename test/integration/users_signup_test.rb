require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup info" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'

    assert_select "#error_explanation" do
      assert_select 'li:nth-child(1)', "Name can't be blank"
      assert_select 'li:nth-child(2)', "Email is invalid"
      assert_select 'li:nth-child(3)', "Password confirmation doesn't match Password"
      assert_select 'li:nth-child(4)', "Password is too short (minimum is 6 characters)"
    end
  end
end
