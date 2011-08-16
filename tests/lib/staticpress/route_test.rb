require_relative '../../test_helper'

require 'staticpress/site'
require 'staticpress/route'

class RouteTest < TestHelper
  def setup
    Staticpress.blog_path = TEST_BLOG

    @route_page = Staticpress::Route.new :content_type => Staticpress::Content::Page, :slug => 'about'
    @route_post = Staticpress::Route.new :content_type => Staticpress::Content::Post, :year => '2011', :month => '07', :day => '20', :title => 'hello'

    @page = Staticpress::Content::Page.new @route_page, :markdown
    @post = Staticpress::Content::Post.new @route_post, :markdown
  end

  def test__equalsequals
    assert_operator @route_page, :==, Staticpress::Route.new(:content_type => Staticpress::Content::Page, :slug => 'about')
    refute_operator @route_page, :==, @route_post
    refute_operator @route_page, :==, nil
  end

  def test_content
    assert_equal @page, @route_page.content
    assert_equal @post, @route_post.content
  end

  def test_inspect
    assert_equal '#<Staticpress::Route url_path=/about, content_type=Staticpress::Content::Page, params={:slug=>"about"}>', @route_page.inspect
    assert_equal '#<Staticpress::Route url_path=/2011/07/20/hello, content_type=Staticpress::Content::Post, params={:day=>"20", :month=>"07", :title=>"hello", :year=>"2011"}>', @route_post.inspect
  end

  def test_params
    assert_equal({ :content_type => Staticpress::Content::Page, :slug => 'about' }, @route_page.params)
    assert_equal({ :content_type => Staticpress::Content::Post, :year => '2011', :month => '07', :day => '20', :title => 'hello' }, @route_post.params)
  end

  def test_file_path
    assert_equal (Staticpress.blog_path + 'public' + 'about' + 'index.html'), @route_page.file_path
    assert_equal (Staticpress.blog_path + 'public' + '2011' + '07' + '20' + 'hello' + 'index.html'), @route_post.file_path
  end

  def test_url_path
    assert_equal '/about', @route_page.url_path
    assert_equal '/2011/07/20/hello', @route_post.url_path
  end

  def test_from_url_path
    assert_equal Staticpress::Route.from_url_path('/about'), @route_page
    assert_equal Staticpress::Route.from_url_path('/2011/07/20/hello'), @route_post
    assert_nil Staticpress::Route.from_url_path('/i/dont/exist')
  end

  def test_regex_for_pattern_index
    pattern = '/'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
  end

  def test_regex_for_pattern_page_1
    pattern = '/:slug'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_page_2
    pattern = '/static_text/:slug'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_1
    pattern = '/:year/:month/:day/:title'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_2
    pattern = '/blog/:year/:month/:day/:title'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_3
    pattern = '/:year/:title'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_4
    pattern = '/blog/:year/:title'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/hello-world'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_tag
    pattern = '/tag/:name'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_category
    pattern = '/category/:name'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end
end
