require_relative '../../test_case'

require 'staticpress/content/base'
require 'staticpress/content/category'
require 'staticpress/content/page'
require 'staticpress/content/post'

class ContentBaseTest < TestCase
  def setup
    super

    @category_0 = Staticpress::Content::Category.new(:name => 'programming', :number => nil)
    @category_1 = Staticpress::Content::Category.new(:name => 'programming', :number => '1')
    @category_2 = Staticpress::Content::Category.new(:name => 'programming', :number => '2')
    @page = Staticpress::Content::Page.new(:slug => 'about')
    @custom_index = Staticpress::Content::Page.new(:slug => '')
    @post = Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello')
  end

  def test_url_path
    assert_equal '/category/programming', @category_0.url_path
    assert_equal '/category/programming', @category_1.url_path
    assert_equal '/category/programming/page/2', @category_2.url_path
    assert_equal '/about', @page.url_path
    assert_equal '/', @custom_index.url_path
    assert_equal '/2011/07/20/hello', @post.url_path
  end
end
