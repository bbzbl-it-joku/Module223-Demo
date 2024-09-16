require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "#valid?" do
    post = Post.new
    post.valid?
    assert post.errors.added?(:title, :blank)
    assert post.errors.added?(:body, :blank)
    assert_not post.errors.added?(:published_at, :blank)
  end

  test "#set_slug" do
    post = Post.new(title: "Hello World", body: "Lorem ipsum")
    post.save!
    assert_equal "hello-world", post.slug
  end

  test "#published?" do
    post = Post.new
    assert_not post.published?
    post.published_at = Time.current
    assert post.published?
    post.published_at = Time.current.tomorrow
    assert_not post.published?
  end
end
