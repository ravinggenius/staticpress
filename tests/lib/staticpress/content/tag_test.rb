require_relative 'base_test'

require 'staticpress/content/tag'
require 'staticpress/route'
require 'staticpress/theme'

class ContentTagTest < ContentBaseTest
  def setup
    super

    @template_dir = Staticpress::Theme.theme.root + '_views'

    @tag_page_route = Staticpress::Route.from_url_path '/tag/charlotte'
    @tag_page = Staticpress::Content::Tag.new @tag_page_route, @template_dir + 'default.haml'
  end

  def test__equalsequals
    assert_operator @tag_page, :==, Staticpress::Content::Tag.new(@tag_page_route, @template_dir + 'default.haml')
    refute_operator @tag_page, :==, nil
  end

  def test_tags
    assert_equal [ 'charlotte' ], Staticpress::Content::Tag.tags
  end

  def test_exist?
    assert @tag_page.exist?, '@tag_page does not exist'
  end

  def test_find_by_route
    assert_equal @tag_page, Staticpress::Content::Tag.find_by_route(@tag_page_route)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Tag url_path=/tag/charlotte>', @tag_page.inspect
  end

  def test_sub_content
    assert_equal 1, @tag_page.sub_content.count
  end

  def test_raw
    assert_equal '= partial :list_posts, :posts => page.sub_content', @tag_page.raw
  end

  def test_route
    assert_equal '/tag/charlotte', @tag_page.route.url_path
  end

  def test_all
    assert_equal 1, Staticpress::Content::Tag.all.count
    assert Staticpress::Content::Tag.all.include?(@tag_page)
  end

  def test_content_by_tag
    [
      Staticpress::Route.new(:content_type => Staticpress::Content::Post, :year => '2011', :month => '08', :day => '06', :title => 'in-charlotte').content
    ].each { |content| assert_includes Staticpress::Content::Tag.content_by_tag['charlotte'], content }
  end
end
