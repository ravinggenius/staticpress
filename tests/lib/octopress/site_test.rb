require_relative '../../test_helper'

require 'octopress/content/page'
require 'octopress/content/post'
require 'octopress/route'
require 'octopress/site'

class SiteTest < TestHelper
  def setup
    Octopress.blog_path = TEST_BLOG
    @site = Octopress::Site.new

    @page_route = Octopress::Route.from_url_path '/about'
    @page = Octopress::Content::Page.new @page_route, :markdown

    @post_route = Octopress::Route.from_url_path '/2011/07/20/hello'
    @post = Octopress::Content::Post.new @post_route, :markdown
  end

  def test_find_content_by_url_path
    assert_equal @page, @site.find_content_by_url_path('/about')
    assert_equal @post, @site.find_content_by_url_path('/2011/07/20/hello')
    assert_nil @site.find_content_by_url_path('/i/dont/exist')
  end
end
