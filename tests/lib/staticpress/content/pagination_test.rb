require_relative 'base_test'

require 'staticpress/content/pagination'
require 'staticpress/route'

class ContentPaginationTest < ContentBaseTest
  def setup
    super

    @template_dir = Staticpress::Theme.theme.root + '_views'

    @page_one_route = Staticpress::Route.from_url_path '/page/1'
    @page_one = Staticpress::Content::Pagination.new @page_one_route, @template_dir + 'default.haml'

    @page_two_route = Staticpress::Route.from_url_path '/page/2'
    @page_two = Staticpress::Content::Pagination.new @page_two_route, @template_dir + 'default.haml'
  end

  def test__equalsequals
    assert_operator @page_one, :==, Staticpress::Content::Pagination.new(@page_one_route, @template_dir + 'default.haml')
    refute_operator @page_one, :==, @page_two
    refute_operator @page_one, :==, nil
  end

  def test_exist?
    assert @page_one.exist?, '@page_one does not exist'
    assert @page_two.exist?, '@page_two does not exist'
  end

  def test_find_by_route
    assert_equal @page_one, Staticpress::Content::Pagination.find_by_route(@page_one_route)
    assert_equal @page_two, Staticpress::Content::Pagination.find_by_route(@page_two_route)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Pagination url_path=/page/1>', @page_one.inspect
  end

  def test_raw
  end

  def test_route
    assert_equal '/page/1', @page_one.route.url_path
    assert_equal '/page/2', @page_two.route.url_path
  end
end
