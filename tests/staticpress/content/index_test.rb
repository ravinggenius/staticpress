require_relative '../../test_case'

require 'staticpress/content/index'
require 'staticpress/route'

class ContentIndexTest < TestCase
  def setup
    super

    @template_dir = Staticpress::Theme.theme.root + 'views'

    @home = Staticpress::Content::Index.new :number => 1
    @home_two = Staticpress::Content::Index.new :number => 2
  end

  def test__equalsequals
    assert_operator @home, :==, Staticpress::Content::Index.new(:number => 1)
    refute_operator @home, :==, @home_two
    refute_operator @home, :==, nil
  end

  def test_exist?
    assert @home.exist?, '@home does not exist'
  end

  def test_find_by_url_path
    assert_equal @home, Staticpress::Content::Index.find_by_url_path('/')
  end

  def test_to_s
    assert_equal '#<Staticpress::Content::Index url_path=/, params={:number=>1}>', @home.to_s
    assert_equal '#<Staticpress::Content::Index url_path=/page/2, params={:number=>2}>', @home_two.to_s
  end

  def test_raw
  end

  def test_url_path
    assert_equal '/', @home.url_path
    assert_equal '/page/2', @home_two.url_path
  end
end
