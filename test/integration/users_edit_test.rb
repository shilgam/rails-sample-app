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
end
