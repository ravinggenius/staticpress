require_relative '../../test_helper'

require 'staticpress/content/page'
require 'staticpress/content/post'
require 'staticpress/route'
require 'staticpress/site'

class SiteTest < TestHelper
  def setup
    super

    @site = Staticpress::Site.new

    @page_route = Staticpress::Route.from_url_path '/about'
    @page = Staticpress::Content::Page.new @page_route, :markdown

    @post_route = Staticpress::Route.from_url_path '/2011/07/20/hello'
    @post = Staticpress::Content::Post.new @post_route, :markdown
  end

  def test_find_content_by_url_path
    assert_equal @page, @site.find_content_by_url_path('/about')
    assert_equal @post, @site.find_content_by_url_path('/2011/07/20/hello')
    assert_nil @site.find_content_by_url_path('/i/dont/exist')
  end
end
