require_relative 'base_test'

require 'staticpress/content/category'
require 'staticpress/route'
require 'staticpress/theme'

class ContentCategoryTest < ContentBaseTest
  def setup
    super

    @template_dir = Staticpress::Theme.theme.root + '_views'

    @category_page_route = Staticpress::Route.from_url_path '/category/programming'
    @category_page = Staticpress::Content::Category.new @category_page_route, @template_dir + 'default.haml'
  end

  def test__equalsequals
    assert_operator @category_page, :==, Staticpress::Content::Category.new(@category_page_route, @template_dir + 'default.haml')
    refute_operator @category_page, :==, nil
  end

  def test_categories
    assert_equal [ 'programming', 'travel' ], Staticpress::Content::Category.categories
  end

  def test_exist?
    assert @category_page.exist?, '@category_page does not exist'
  end

  def test_find_by_route
    assert_equal @category_page, Staticpress::Content::Category.find_by_route(@category_page_route)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Category url_path=/category/programming>', @category_page.inspect
  end

  def test_sub_content
    assert_equal 3, @category_page.sub_content.count
  end

  def test_raw
    assert_equal '= partial :list_posts, :posts => page.sub_content', @category_page.raw
  end

  def test_route
    assert_equal '/category/programming', @category_page.route.url_path
  end

  def test_all
    assert_equal 2, Staticpress::Content::Category.all.count
    assert Staticpress::Content::Category.all.include?(@category_page)
  end

  def test_content_by_category
    [
      Staticpress::Route.new(:content_type => Staticpress::Content::Post, :year => '2011', :month => '08', :day => '01', :title => 'announcing-staticpress').content,
      Staticpress::Route.new(:content_type => Staticpress::Content::Post, :year => '2011', :month => '08', :day => '02', :title => 'staticpress').content,
      Staticpress::Route.new(:content_type => Staticpress::Content::Post, :year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress').content
    ].each { |content| assert_includes Staticpress::Content::Category.content_by_category['programming'], content }
  end
end
