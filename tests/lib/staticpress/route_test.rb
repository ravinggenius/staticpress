require_relative '../../test_helper'

require 'staticpress/site'
require 'staticpress/route'

class RouteTest < TestHelper
  def setup
    Staticpress.blog_path = TEST_BLOG

    @route_page = Staticpress::Route.new :url_path => '/about', :content_type => Staticpress::Content::Page, :slug => 'about'
    @route_post = Staticpress::Route.new :url_path => '/2011/07/20/hello', :content_type => Staticpress::Content::Post, :year => '2011', :month => '07', :day => '20', :title => 'hello'
    @route_fake = Staticpress::Route.new :url_path => '/i/dont/exist'

    @page = Staticpress::Content::Page.new @route_page, :markdown
    @post = Staticpress::Content::Post.new @route_post, :markdown
  end

  def test__equalsequals
    assert_operator @route_page, :==, Staticpress::Route.new(:url_path => '/about', :content_type => Staticpress::Content::Page, :slug => 'about')
    refute_operator @route_page, :==, @route_post
    refute_operator @route_page, :==, @route_fake
  end

  def test_content
    assert_equal @page, @route_page.content
    assert_equal @post, @route_post.content
    assert_nil @route_fake.content
  end

  def test_inspect
    assert_equal '#<Staticpress::Route url_path=/about, content_type=Staticpress::Content::Page, params={:slug=>"about"}>', @route_page.inspect
    assert_equal '#<Staticpress::Route url_path=/2011/07/20/hello, content_type=Staticpress::Content::Post, params={:day=>"20", :month=>"07", :title=>"hello", :year=>"2011"}>', @route_post.inspect
    assert_equal '#<Staticpress::Route url_path=/i/dont/exist, params={}>', @route_fake.inspect
  end

  def test_params
    assert_equal({ :url_path => '/about', :content_type => Staticpress::Content::Page, :slug => 'about' }, @route_page.params)
    assert_equal({ :url_path => '/2011/07/20/hello', :content_type => Staticpress::Content::Post, :year => '2011', :month => '07', :day => '20', :title => 'hello' }, @route_post.params)
    assert_equal({ :url_path => '/i/dont/exist' }, @route_fake.params)
  end

  def test_file_path
    assert_equal (Staticpress.blog_path + 'public' + 'about' + 'index.html'), @route_page.file_path
    assert_equal (Staticpress.blog_path + 'public' + '2011' + '07' + '20' + 'hello' + 'index.html'), @route_post.file_path
    assert_equal (Staticpress.blog_path + 'public' + 'i' + 'dont' + 'exist' + 'index.html'), @route_fake.file_path
  end

  def test_url_path
    assert_equal '/about', @route_page.url_path
    assert_equal '/2011/07/20/hello', @route_post.url_path
    assert_equal '/i/dont/exist', @route_fake.url_path
  end

  def test_from_url_path
    assert_equal Staticpress::Route.from_url_path('/about'), @route_page
    assert_equal Staticpress::Route.from_url_path('/2011/07/20/hello'), @route_post, ':slug should not appear in Post route\'s params'
    assert_equal Staticpress::Route.from_url_path('/i/dont/exist'), @route_fake
  end

  def test_regex_for_pattern
    pattern_1 = '/:slug'
    pattern_2 = '/static_text/:slug'
    pattern_3 = '/:year/:month/:day/:title'
    pattern_4 = '/blog/:year/:month/:day/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern_1), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern_2), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern_3), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern_4), '/about'

    assert_match Staticpress::Route.regex_for_pattern(pattern_1), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern_2), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern_3), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern_4), '/about/us'

    assert_match Staticpress::Route.regex_for_pattern(pattern_1), '/static_text/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern_2), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern_3), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern_4), '/static_text/about'

    assert_match Staticpress::Route.regex_for_pattern(pattern_1), '/static_text/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern_2), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern_3), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern_4), '/static_text/about/us'

    assert_match Staticpress::Route.regex_for_pattern(pattern_1), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern_2), '/2011/07/20/hello-world'
    assert_match Staticpress::Route.regex_for_pattern(pattern_3), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern_4), '/2011/07/20/hello-world'

    assert_match Staticpress::Route.regex_for_pattern(pattern_1), '/blog/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern_2), '/blog/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern_3), '/blog/2011/07/20/hello-world'
    assert_match Staticpress::Route.regex_for_pattern(pattern_4), '/blog/2011/07/20/hello-world'
  end
end
