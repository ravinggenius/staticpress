require_relative 'base_test'

require 'octopress/content/post'
require 'octopress/route'

class ContentPostTest < ContentBaseTest
  def setup
    super

    @post_route = Octopress::Route.from_url_path '/2011/07/20/hello'
    @post = Octopress::Content::Post.new @post_route, :markdown

    @second_post_route = Octopress::Route.from_url_path '/2011/07/20/goodbye'
    @second_post = Octopress::Content::Post.new @second_post_route, :markdown
  end

  def test__equalsequals
    assert_operator @post, :==, Octopress::Content::Post.new(@post_route, :markdown)
    refute_operator @post, :==, @second_post
    refute_operator @post, :==, nil
  end

  def test_exist?
    assert @post.exist?, '@post does not exist'
    refute @second_post.exist?, '@second_post does not exist'
  end

  def test_find_by_route
    assert_equal @post, Octopress::Content::Post.find_by_route(@post_route)
    assert_nil Octopress::Content::Post.find_by_route(Octopress::Route.from_url_path('/i/dont/exist'))
  end

  def test_inspect
    assert_equal '#<Octopress::Content::Post url_path=/2011/07/20/hello>', @post.inspect
  end
end
