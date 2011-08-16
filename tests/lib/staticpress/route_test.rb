require_relative '../../test_helper'

require 'staticpress/site'
require 'staticpress/route'

class RouteTest < TestHelper
  def setup
    Staticpress.blog_path = TEST_BLOG

    @route_category_0 = Staticpress::Route.new :content_type => Staticpress::Content::Category, :name => 'programming', :number => nil
    @route_category_1 = Staticpress::Route.new :content_type => Staticpress::Content::Category, :name => 'programming', :number => '1'
    @route_category_2 = Staticpress::Route.new :content_type => Staticpress::Content::Category, :name => 'programming', :number => '2'
    @route_page = Staticpress::Route.new :content_type => Staticpress::Content::Page, :slug => 'about'
    @route_post = Staticpress::Route.new :content_type => Staticpress::Content::Post, :year => '2011', :month => '07', :day => '20', :title => 'hello'
  end

  def test__equalsequals
    assert_operator @route_category_0, :==, @route_category_1
    refute_operator @route_category_0, :==, @route_category_2
    assert_operator @route_page, :==, Staticpress::Route.new(:content_type => Staticpress::Content::Page, :slug => 'about')
    refute_operator @route_page, :==, @route_post
    refute_operator @route_page, :==, nil
  end

  def test_content
    assert_equal Staticpress::Content::Page.new(@route_page, :markdown), @route_page.content
    assert_equal Staticpress::Content::Post.new(@route_post, :markdown), @route_post.content
  end

  def test_inspect
    assert_equal '#<Staticpress::Route url_path=/about, content_type=Staticpress::Content::Page, params={:slug=>"about"}>', @route_page.inspect
    assert_equal '#<Staticpress::Route url_path=/2011/07/20/hello, content_type=Staticpress::Content::Post, params={:day=>"20", :month=>"07", :title=>"hello", :year=>"2011"}>', @route_post.inspect
  end

  def test_params
    assert_equal({ :content_type => Staticpress::Content::Category, :name => 'programming', :number => '1' }, @route_category_0.params)
    assert_equal({ :content_type => Staticpress::Content::Category, :name => 'programming', :number => '1' }, @route_category_1.params)
    assert_equal({ :content_type => Staticpress::Content::Page, :slug => 'about' }, @route_page.params)
    assert_equal({ :content_type => Staticpress::Content::Post, :year => '2011', :month => '07', :day => '20', :title => 'hello' }, @route_post.params)
  end

  def test_file_path
    assert_equal (Staticpress.blog_path + 'public' + 'about' + 'index.html'), @route_page.file_path
    assert_equal (Staticpress.blog_path + 'public' + '2011' + '07' + '20' + 'hello' + 'index.html'), @route_post.file_path
  end

  def test_url_path
    assert_equal '/category/programming', @route_category_0.url_path
    assert_equal '/category/programming', @route_category_1.url_path
    assert_equal '/category/programming/page/2', @route_category_2.url_path
    assert_equal '/about', @route_page.url_path
    assert_equal '/2011/07/20/hello', @route_post.url_path
  end

  def test_from_url_path
    assert_equal Staticpress::Route.from_url_path('/about'), @route_page
    assert_equal Staticpress::Route.from_url_path('/2011/07/20/hello'), @route_post
    assert_nil Staticpress::Route.from_url_path('/i/dont/exist')
  end

  def test_regex_for_pattern_index
    pattern = '/(page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/page/1'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/page/2'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/page/17'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/contact/page/27'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
  end

  def test_regex_for_pattern_page_1
    pattern = '/:slug'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/page/1'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
  end

  def test_regex_for_pattern_page_2
    pattern = '/static_text/:slug'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/page/123'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/page/xyz'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_1
    pattern = '/:year/:month/:day/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_2
    pattern = '/blog/:year/:month/:day/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_3
    pattern = '/:year/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_4
    pattern = '/blog/:year/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_tag_1
    pattern = '/tag/:name(/page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/tag/programming'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/tag/programming/page/0'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/something/tag/programming'
  end

  def test_regex_for_pattern_tag_2
    pattern = '/something/tag/:name(/page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/something/tag/programming'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/something/tag/programming/page/123456'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/tag/programming'
  end

  def test_regex_for_pattern_category_1
    pattern = '/category/:name(/page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/category/programming'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/category/programming/page/5'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_category_2
    pattern = '/blog/category/:name(/page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/category/programming'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/category/programming/page/20'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/category/programming'
  end
end
