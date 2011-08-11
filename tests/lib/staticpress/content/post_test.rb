require_relative 'base_test'

require 'staticpress/content/post'
require 'staticpress/helpers'
require 'staticpress/route'

class ContentPostTest < ContentBaseTest
  include Staticpress::Helpers

  def setup
    super

    @post_route = Staticpress::Route.from_url_path '/2011/07/20/hello'
    @post = Staticpress::Content::Post.new @post_route, :markdown

    @second_post_route = Staticpress::Route.from_url_path '/2011/07/20/goodbye'
    @second_post = Staticpress::Content::Post.new @second_post_route, :markdown
  end

  def test__equalsequals
    assert_operator @post, :==, Staticpress::Content::Post.new(@post_route, :markdown)
    refute_operator @post, :==, @second_post
    refute_operator @post, :==, nil
  end

  def test_exist?
    assert @post.exist?, '@post does not exist'
    refute @second_post.exist?, '@second_post does not exist'
  end

  def test_find_by_path
    posts_dir = Staticpress.blog_path + config.posts_source
    assert_equal @post, Staticpress::Content::Post.find_by_path(posts_dir + '2011-07-20-hello.markdown')
    assert_nil Staticpress::Content::Post.find_by_path(posts_dir + '2011-07-20-goodbye.markdown')
  end

  def test_find_by_route
    assert_equal @post, Staticpress::Content::Post.find_by_route(@post_route)
    assert_nil Staticpress::Content::Post.find_by_route(Staticpress::Route.from_url_path('/i/dont/exist'))
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Post url_path=/2011/07/20/hello>', @post.inspect
  end

  def test_raw
    assert_equal 'in post', @post.raw
    assert_equal '', @second_post.raw
  end

  def test_render_partial
    assert_equal "<p>in post</p>\n", @post.render_partial
    assert_equal "\n", @second_post.render_partial
  end

  def test_route
    assert_equal '/2011/07/20/hello', @post.route.url_path
    assert_nil @second_post.route.url_path
  end
end
