require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
  end

  test "micropost interface" do
    log_in_as @user
    get root_path
    assert_select '.user_feed .pagination'
    assert_select 'form#new_micropost' do
      assert_select 'textarea[placeholder=?]', "Compose new micropost..."
      assert_select '.btn[value=?]', "Post"
    end
    assert_select '.user_info' do
      assert_select 'h1', @user.name
      assert_select 'a[href=?]', user_path(@user), text: "view my profile"
    end

    # feed
    assert_select '.user_feed' do
      assert_select 'h3', "Micropost Feed"
      assert_select '.microposts'
      assert_select '.pagination'
    end
  end

  test "create mircopost" do
    log_in_as @user

    # Invalid submission
    get root_path
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select ".new_micropost #error_explanation" do
      assert_select 'li:nth-child(1)', "Content can't be blank"
    end

    # Valid submission
    get root_path
    content = "Valid micropost content"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_equal flash[:success], "Micropost created!"
    assert_match content, response.body
  end

  test "delete micropost" do
    log_in_as @user

    # in the Home page
    content = "post created by me"
    @micropost = @user.microposts.create(content: content)
    get root_path
    assert_select '.user_feed' do
      assert_select "#micropost-#{@micropost.id}" do
        assert_select '.content', @micropost.content
        assert_select 'a[data-method=?]', "delete"
        assert_select 'a[data-confirm=?]', "You sure?"
      end
    end
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_equal flash[:success], "Micropost deleted"

    # in the user's profile page
    @micropost = @user.microposts.create(content: content)
    get user_path(@user)
    assert_select '.user_feed' do
      assert_select "#micropost-#{@micropost.id}" do
        assert_select '.content', @micropost.content
        assert_select 'a[data-method=?]', "delete"
        assert_select 'a[data-confirm=?]', "You sure?"
      end
    end
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@micropost),
             headers: { "HTTP_REFERER" => user_url(@user) }
    end
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_equal flash[:success], "Micropost deleted"

    # Visit different user (no delete links)
    get user_path(users(:other_user))
    assert_select '.user_feed .microposts' do
      assert_select '.content'
      assert_select 'a', text: 'delete', count: 0
    end
  end
end
