require_relative '../../test_helper'

require 'octopress/site'

class SiteTest < TestHelper
  def setup
    Octopress.blog_path = READONLY
    @site = Octopress::Site.new
    @page = Octopress::Content::Page.new(@site.directory + 'about.markdown')
    @post = Octopress::Content::Post.new(@site.directory + '_posts' + '2011-07-20-hello.markdown')
  end

  def test_find_page_by_route
    assert_equal @page, @site.find_page_by_route('/about')
    assert_equal @post, @site.find_page_by_route('/2011/07/20/hello')
    assert_nil @site.find_page_by_route('/i/dont/exist')
  end
end
