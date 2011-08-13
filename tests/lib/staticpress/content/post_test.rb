require_relative 'base_test'

require 'staticpress/content/post'
require 'staticpress/helpers'
require 'staticpress/route'

class ContentPostTest < ContentBaseTest
  include Staticpress::Helpers

  def setup
    super

    @post_dir = Staticpress.blog_path + config.posts_source

    @post_route = Staticpress::Route.from_url_path '/2011/07/20/hello'
    @post = Staticpress::Content::Post.new @post_route, @post_dir + '2011-07-20-hello.markdown'
  end

  def test__equalsequals
    assert_operator @post, :==, Staticpress::Content::Post.new(@post_route, @post_dir + '2011-07-20-hello.markdown')
    refute_operator @post, :==, nil
  end

  def test_created_on
    assert_equal Date.new(2011, 07, 20), @post.created_on
  end

  def test_exist?
    assert @post.exist?, '@post does not exist'
  end

  def test_find_by_path
    @post_dir = Staticpress.blog_path + config.posts_source
    assert_equal @post, Staticpress::Content::Post.find_by_path(@post_dir + '2011-07-20-hello.markdown')
    assert_nil Staticpress::Content::Post.find_by_path(@post_dir + '2011-07-20-goodbye.markdown')
  end

  def test_find_by_route
    assert_equal @post, Staticpress::Content::Post.find_by_route(@post_route)
    assert_nil Staticpress::Content::Post.find_by_route(nil)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Post url_path=/2011/07/20/hello>', @post.inspect
  end

  def test_raw
    assert_equal 'in post', @post.raw
  end

  def test_render_partial
    assert_equal "<p>in post</p>\n", @post.render_partial
  end

  def test_route
    assert_equal '/2011/07/20/hello', @post.route.url_path
  end
end
