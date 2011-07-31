require_relative '../../test_helper'

require 'octopress/route'

class RouteTest < TestHelper
  def setup
    Octopress.blog_path = READONLY

    @route_page = Octopress::Route.new :url_path => '/about', :content_type => Octopress::Content::Page, :slug => 'about', :title => 'about'
    @route_post = Octopress::Route.new :url_path => '/2011/07/20/hello', :content_type => Octopress::Content::Post, :year => '2011', :month => '07', :day => '20', :title => 'hello'
    @route_fake = Octopress::Route.new :url_path => '/i/dont/exist'

    @page = Octopress::Content::Page.new @route_page, :markdown
    @post = Octopress::Content::Post.new @route_post, :markdown
  end

  def test__equalsequals
    assert_operator @route_page, :==, Octopress::Route.new(:url_path => '/about', :content_type => Octopress::Content::Page, :slug => 'about', :title => 'about')
    refute_operator @route_page, :==, @route_post
    refute_operator @route_page, :==, @route_fake
  end

  def test_content
    assert_equal @page, @route_page.content
    assert_equal @post, @route_post.content
    assert_nil @route_fake.content
  end

  def test_inspect
    assert_equal '#<Octopress::Route url_path=/about, content_type=Octopress::Content::Page, params={:slug=>"about", :title=>"about"}>', @route_page.inspect
    assert_equal '#<Octopress::Route url_path=/2011/07/20/hello, content_type=Octopress::Content::Post, params={:day=>"20", :month=>"07", :title=>"hello", :year=>"2011"}>', @route_post.inspect
    assert_equal '#<Octopress::Route url_path=/i/dont/exist, params={}>', @route_fake.inspect
  end

  def test_params
    assert_equal({ :url_path => '/about', :content_type => Octopress::Content::Page, :slug => 'about', :title => 'about' }, @route_page.params)
    assert_equal({ :url_path => '/2011/07/20/hello', :content_type => Octopress::Content::Post, :year => '2011', :month => '07', :day => '20', :title => 'hello' }, @route_post.params)
    assert_equal({ :url_path => '/i/dont/exist' }, @route_fake.params)
  end

  def test_file_path
    assert_equal (Octopress.blog_path + 'public' + 'about' + 'index.html'), @route_page.file_path
    assert_equal (Octopress.blog_path + 'public' + '2011' + '07' + '20' + 'hello' + 'index.html'), @route_post.file_path
    assert_equal (Octopress.blog_path + 'public' + 'i' + 'dont' + 'exist' + 'index.html'), @route_fake.file_path
  end

  def test_url_path
    assert_equal '/about', @route_page.url_path
    assert_equal '/2011/07/20/hello', @route_post.url_path
    assert_equal '/i/dont/exist', @route_fake.url_path
  end

  def test_from_url_path
    assert_equal Octopress::Route.from_url_path('/about'), @route_page
    assert_equal Octopress::Route.from_url_path('/2011/07/20/hello'), @route_post, ':slug should not appear in Post route\'s params'
    assert_equal Octopress::Route.from_url_path('/i/dont/exist'), @route_fake
  end
end
