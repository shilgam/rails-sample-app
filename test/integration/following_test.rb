require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
    log_in_as(@user)
  end

  test "follow button" do
    @unknown = users(:guest)
    get user_path(@unknown)
    assert_select '#follow_form .btn[value=?]', "Follow"
  end

  test "unfollow button" do
    @star = users(:superstar)
    get user_path(@star)
    assert_select '#follow_form .btn[value=?]', "Unfollow"
  end

  test "follow / unfollow buttons if current user" do
    get user_path(@user)
    assert_select '#follow_form', count: 0
  end

  test "following/followers page" do
    @other = users(:other_user)
    @star = users(:superstar)
    @other.follow(@star)

    # following page
    get following_user_path(@other)
    assert_select 'section.user_info' do
      assert_select '.gravatar'
      assert_select 'h3', @other.name
      assert_select "a[href=?]", user_path(@other), text: "view my profile"
      assert_select '#microposts_count', "Microposts: #{@other.following.count}"
    end
    assert_select 'section.stats' do
      assert_select '.gravatar'
      @other.following.each do |user|
        assert_select 'a[href=?]', user_path(user)
      end
    end
    assert_select '.col-md-8' do
      assert_select 'h1', "Following"
      assert_not @other.following.empty?
      @other.following.each do |user|
        assert_select "a[href=?]", user_path(user)
      end
    end

    # followers page
    get followers_user_path(@star)
    assert_select 'section.user_info' do
      assert_select '.gravatar'
      assert_select 'h3', @star.name
      assert_select "a[href=?]", user_path(@star), text: "view my profile"
      assert_select '#microposts_count', "Microposts: #{@star.following.count}"
    end
    assert_select '.col-md-8' do
      assert_select 'h1', "Followers"
      assert_not @star.followers.empty?
      @star.followers.each do |user|
        assert_select "a[href=?]", user_path(user)
      end
    end
  end
end
