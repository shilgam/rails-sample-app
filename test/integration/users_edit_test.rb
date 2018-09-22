require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessfull edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: {
      name: "",
      email: "user@invalid",
      password: "foo",
      password_confirmation: "bar"
    } }
    assert_template 'users/edit'

    assert_select "#error_explanation" do
      assert_select '.alert-danger', 'The form contains 4 errors.'
    end
  end

  test "successful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Valid User"
    email = "user@valid.com"

    patch user_path(@user), params: { user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
