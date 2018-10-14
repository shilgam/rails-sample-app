require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:non_admin_user)
    @micropost = @user.microposts.build(content: "Lorum ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user_id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should not be too long" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end
