require_relative '../../test_helper'

require 'octopress/site'

class SiteTest < TestHelper
  def setup
    Octopress.blog_path = READONLY
    @site = Octopress::Site.new
  end

  def test_find_page_by_route
    about = Octopress::Content::Page.new(@site.directory + 'about.markdown')
    assert_equal about.route, @site.find_page_by_route('/about').route
  end
end
