require_relative 'base_test'

require 'octopress/content/category'
require 'octopress/route'

class ContentCategoryTest < ContentBaseTest
  def setup
    super

    @category_page_route = Octopress::Route.from_url_path '/category/programming'
    @category_page = Octopress::Content::Category.new @category_page_route, :markdown
  end

  def test__equalsequals
    assert_operator @category_page, :==, Octopress::Content::Category.new(@category_page_route, :markdown)
    refute_operator @category_page, :==, nil
  end

  def test_exist?
    assert @category_page.exist?, '@category_page does not exist'
  end

  def test_find_by_route
    assert_equal @category_page, Octopress::Content::Category.find_by_route(@category_page_route)
  end

  def test_inspect
    assert_equal '#<Octopress::Content::Category url_path=/category/programming>', @category_page.inspect
  end

  def test_raw
  end

  def test_route
    assert_equal '/category/programming', @category_page.route.url_path
  end
end
