require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @non_admin = users(:non_admin_user)
    @admin = users(:admin_user)
  end

  test "index as admin" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)

    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: 'delete'
      end
    end

    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
    assert_redirected_to users_path
  end

  test "index as non-admin" do
    log_in_as @non_admin
    get users_path
    assert_select "a", text: 'delete', count: 0
  end

  test "index shows only activated users" do
    log_in_as @non_admin
    get users_path
    first_page_of_users = User.paginate(page: 1)
    user = first_page_of_users.first
    assert_select "a[href=?]", user_path(user), text: user.name
    user.update_attribute(:activated, false)

    get users_path
    assert_select "a[href=?]", user_path(user), count: 0
  end
end
