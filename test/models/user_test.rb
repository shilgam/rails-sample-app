require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "mypass", password_confirmation: "mypass")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAmPlE.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    @user.save
    assert_not @user.valid?
  end

  test "password should have mimimum lenght" do
    @user.password = @user.password_confirmation = "a" * 5
    @user.save
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user w/ nil remember_digest" do
    assert_not @user.authenticated?(:remember, nil)
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "user's post")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    @user = users(:non_admin_user)
    @other = users(:other_user)
    assert_not @user.following?(@other)
    assert_not @other.followers.include?(@user)

    @user.follow(@other)
    assert @user.following?(@other)
    assert @other.followers.include?(@user)

    @user.unfollow(@other)
    assert_not @user.following?(@other)
    assert_not @other.followers.include?(@user)
  end

  test "feed should have the right posts" do
    @user = users(:non_admin_user)
    @star = users(:elon_musk)
    @other = users(:other_user)
    @user.follow(@star)
    @user.microposts.create!(content: "post from self")
    @star.microposts.create!(content: "post from star")
    @other.microposts.create!(content: "post from other user")

    # Posts from followed user
    @star.microposts.each do |post|
      assert @user.feed.include?(post)
    end

    # Posts from self
    @user.microposts.each do |post|
      assert @user.feed.include?(post)
    end

    # Posts from unfollowed user
    @other.microposts.each do |post|
      assert_not @user.feed.include?(post)
    end
  end
end
