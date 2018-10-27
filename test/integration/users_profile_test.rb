require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test "follower stats" do
    get user_path(@user)
    assert_select 'section .stats' do
      assert_select "a[href=?]", following_user_path(@user)
      assert_select "#following", "1"

      assert_select "a[href=?]", followers_user_path(@user)
      assert_select "#followers", "1"
    end
  end

  test "follow / unfollow buttons" do
    # visit following user page
    @star = users(:superstar)
    get user_path(@star)
    assert_select '#follow_form', count: 0

    # visit follower's page
    @star = users(:superstar)
    get user_path(@star)
    assert_select '#follow_form', count: 0
  end
end
