require_relative '../../test_helper'

require 'staticpress/content/base'
require 'staticpress/content/category'
require 'staticpress/content/page'
require 'staticpress/content/post'

class ContentBaseTest < TestHelper
  def setup
    super

    @route_category_0 = Staticpress::Content::Category.new(:name => 'programming', :number => nil)
    @route_category_1 = Staticpress::Content::Category.new(:name => 'programming', :number => '1')
    @route_category_2 = Staticpress::Content::Category.new(:name => 'programming', :number => '2')
    @route_page = Staticpress::Content::Page.new(:slug => 'about')
    @route_custom_index = Staticpress::Content::Page.new(:slug => '')
    @route_post = Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello')
  end

  def test_url_path
    assert_equal '/category/programming', Staticpress::Content::Category.new(:name => 'programming', :number => nil).url_path
    assert_equal '/category/programming', Staticpress::Content::Category.new(:name => 'programming', :number => '1').url_path
    assert_equal '/category/programming/page/2', Staticpress::Content::Category.new(:name => 'programming', :number => '2').url_path
    assert_equal '/about', Staticpress::Content::Page.new(:slug => 'about').url_path
    assert_equal '/', Staticpress::Content::Page.new(:slug => '').url_path
    assert_equal '/2011/07/20/hello', Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello').url_path
  end

  def test_url_path
    assert_equal '/category/programming', @route_category_0.url_path
    assert_equal '/category/programming', @route_category_1.url_path
    assert_equal '/category/programming/page/2', @route_category_2.url_path
    assert_equal '/about', @route_page.url_path
    assert_equal '/', @route_custom_index.url_path
    assert_equal '/2011/07/20/hello', @route_post.url_path
  end
end
