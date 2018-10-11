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
    assert_select "input[type=hidden][name=email][value=?]", user.email

    # Invalid password/confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "password",
                            password_confirmation: "wrong confirmation" } }
    assert_template 'password_resets/edit'
    assert_not logged_in?

    # Empty password/confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "",
                            password_confirmation: "" } }
    assert_template 'password_resets/edit'
    assert_not logged_in?

    # Valid password/confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "password",
                            password_confirmation: "password" } }
    assert_redirected_to user
    assert_equal flash[:success], "Password has been reset."
    assert logged_in?
    assert user.reload.reset_digest.nil?
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    user = assigns(:user) # Password reset form
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "password",
                            password_confirmation: "password" } }
    assert_redirected_to new_password_reset_path
    follow_redirect!
    assert_equal flash[:danger], "Password reset has expired."
    assert_not logged_in?
  end
end
