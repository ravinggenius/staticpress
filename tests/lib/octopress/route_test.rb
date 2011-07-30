require_relative '../../test_helper'

require 'octopress/route'

class RouteTest < TestHelper
  def setup
    Octopress.blog_path = READONLY
    @site = Octopress::Site.new
    @page = Octopress::Content::Page.new(@site.directory + 'about.markdown')
    @post = Octopress::Content::Post.new(@site.directory + '_posts' + '2011-07-20-hello.markdown')
    @route_page = Octopress::Route.new '/about'
    @route_post = Octopress::Route.new '/2011/07/20/hello'
  end

  def test_content
    assert_equal @page, @route_page.content
    assert_equal @post, @route_post.content
    assert_nil Octopress::Route.new('/i/dont/exist').content
  end

  def test_to_file_path
    assert_equal (Octopress.blog_path + 'public' + 'about' + 'index.html'), @route_page.to_file_path
    assert_equal (Octopress.blog_path + 'public' + '2011' + '07' + '20' + 'hello' + 'index.html'), @route_post.to_file_path
  end
end
