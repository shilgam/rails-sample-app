require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
    @other = users(:other_user)
    log_in_as(@user)
  end

  test "follow button" do
    get user_path(@other)
    assert_select '#follow_form .btn[value=?]', "Follow"
  end

  test "unfollow button" do
    @user.follow(@other)
    get user_path(@other)
    assert_select '#follow_form .btn[value=?]', "Unfollow"
  end

  test "follow / unfollow buttons if current user" do
    get user_path(@user)
    assert_select '#follow_form', count: 0
  end

  test "following page" do
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
  end

  test "followers page" do
    @star = users(:superstar)
    @other.follow(@star)
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

  test "should follow a user" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
    assert_redirected_to @other
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
    assert_response :success
  end

  test "should unfollow a user" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
    assert_redirected_to @other
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
    assert_response :success
  end
end
