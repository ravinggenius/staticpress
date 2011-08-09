require_relative 'base_test'

require 'staticpress/content/index'
require 'staticpress/route'

class ContentIndexTest < ContentBaseTest
  def setup
    super

    @home_route = Staticpress::Route.from_url_path '/'
    @home = Staticpress::Content::Index.new @home_route, :markdown

    @page_two_route = Staticpress::Route.from_url_path '/page/2'
    @page_two = Staticpress::Content::Index.new @page_two_route, :markdown
  end

  def test__equalsequals
    assert_operator @home, :==, Staticpress::Content::Index.new(@home_route, :markdown)
    refute_operator @home, :==, @page_two
    refute_operator @home, :==, nil
  end

  def test_exist?
    assert @home.exist?, '@home does not exist'
    assert @page_two.exist?, '@page_two does not exist'
  end

  def test_find_by_route
    assert_equal @home, Staticpress::Content::Index.find_by_route(@home_route)
    assert_equal @page_two, Staticpress::Content::Index.find_by_route(@page_two_route)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Index url_path=/>', @home.inspect
  end

  def test_raw
  end

  def test_route
    assert_equal '/', @home.route.url_path
    assert_equal '/page/2', @page_two.route.url_path
  end
end
