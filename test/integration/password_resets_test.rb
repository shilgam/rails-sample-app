require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
    ActionMailer::Base.deliveries.clear
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # invalid email
    post password_resets_path,
         params: { password_reset: { email: '' } }
    assert_equal flash[:danger], "Email address not found"
    assert_template 'password_resets/new'

    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal flash[:info], "Email sent with password reset instructions"
    assert_redirected_to root_path

    # Password reset form
    user = assigns(:user)

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_path

    # Wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_path

    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_path
    user.toggle!(:activated)

    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
  end
end
