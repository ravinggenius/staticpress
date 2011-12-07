require_relative '../test_case'

require 'staticpress/content/page'
require 'staticpress/content/post'
require 'staticpress/route'
require 'staticpress/site'

class SiteTest < TestCase
  def setup
    super

    @site = Staticpress::Site.new

    @index = Staticpress::Content::Page.new :slug => ''
    @page = Staticpress::Content::Page.new :slug => 'about'
    @post = Staticpress::Content::Post.new :year => '2011', :month => '07', :day => '20', :title => 'hello'
  end

  def test_find_content_by_env
    assert_equal @index, @site.find_content_by_env(env('/'))
    assert_equal @page, @site.find_content_by_env(env('/about'))
    assert_equal @post, @site.find_content_by_env(env('/2011/07/20/hello'))
    assert_nil @site.find_content_by_env(env('/i/dont/exist'))
  end
end
