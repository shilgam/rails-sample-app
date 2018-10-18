require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:non_admin_user)
  end

  test "micropost interface" do
    log_in_as @user
    get root_path

    # Valid submission
    content = "Valid micropost content"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_equal flash[:success], "Micropost created!"
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
end
