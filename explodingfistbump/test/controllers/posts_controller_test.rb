require "test_helper"

class AuthenticatedPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @controller = PostsController.new
    @authorization = ActionController::HttpAuthentication::Basic.encode_credentials("username", "password")
    @post = posts(:one)
  end

  test "should get index" do
    # This is just to sign the user in
    get new_post_url, headers: { "HTTP_AUTHORIZATION" => @authorization }

    get posts_url
    assert_select ".post", 2
    assert_response :success
  end

  test "should get new" do
    get new_post_url, headers: { "HTTP_AUTHORIZATION" => @authorization }
    assert_response :success
  end

  test "should create post" do
    assert_difference("Post.count") do
      post posts_url, params: { post: { body: @post.body, title: @post.title, published_at: @post.published_at } }, headers: { "HTTP_AUTHORIZATION" => @authorization }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should show post" do
    # This is just to sign the user in
    get new_post_url, headers: { "HTTP_AUTHORIZATION" => @authorization }

    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post), headers: { "HTTP_AUTHORIZATION" => @authorization }
    assert_response :success
  end

  test "should update post" do
    patch post_url(@post), params: { post: { body: @post.body, title: @post.title, published_at: @post.published_at } }, headers: { "HTTP_AUTHORIZATION" => @authorization }
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    assert_difference("Post.count", -1) do
      delete post_url(@post), headers: { "HTTP_AUTHORIZATION" => @authorization }
    end

    assert_redirected_to posts_url
  end
end

class UnauthenticatedPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @controller = PostsController.new
    @post = posts(:one)
  end

  test "should get index" do
    get posts_url
    assert_select ".post", 1
    assert_response :success
  end

  test "should get new" do
    get new_post_url
    assert_response :unauthorized
  end

  test "should create post" do
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { body: @post.body, title: @post.title, published_at: @post.published_at } }
    end

    assert_response :unauthorized
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :unauthorized
  end

  test "should update post" do
    patch post_url(@post), params: { post: { body: @post.body, title: @post.title, published_at: @post.published_at } }
    assert_response :unauthorized
  end

  test "should destroy post" do
    assert_no_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_response :unauthorized
  end
end
