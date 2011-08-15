require_relative 'base_test'

require 'staticpress/content/index'
require 'staticpress/route'

class ContentIndexTest < ContentBaseTest
  def setup
    super

    @template_dir = Staticpress::Theme.theme.root + '_views'

    @home_route = Staticpress::Route.from_url_path '/'
    @home = Staticpress::Content::Index.new @home_route, @template_dir + 'default.haml'
  end

  def test__equalsequals
    assert_operator @home, :==, Staticpress::Content::Index.new(@home_route, @template_dir + 'default.haml')
    refute_operator @home, :==, nil
  end

  def test_exist?
    assert @home.exist?, '@home does not exist'
  end

  def test_find_by_route
    assert_equal @home, Staticpress::Content::Index.find_by_route(@home_route)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Index url_path=/>', @home.inspect
  end

  def test_raw
  end

  def test_route
    assert_equal '/', @home.route.url_path
  end
end
