require_relative 'base_test'

require 'staticpress/content/tag'
require 'staticpress/route'
require 'staticpress/theme'

class ContentTagTest < ContentBaseTest
  def setup
    super

    @template_dir = Staticpress::Theme.theme.root + 'views'

    @tag_page = Staticpress::Content::Tag.new :name => 'charlotte'
  end

  def test__equalsequals
    assert_operator @tag_page, :==, Staticpress::Content::Tag.new(:name => 'charlotte')
    refute_operator @tag_page, :==, nil
  end

  def test_tags
    assert_equal [ 'charlotte' ], Staticpress::Content::Tag.tags
  end

  def test_exist?
    assert @tag_page.exist?, '@tag_page does not exist'
  end

  def test_params
    expected = { :name => 'charlotte', :number => 1 }
    assert_equal expected, @tag_page.params
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => nil).params
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => '1').params
  end

  def test_param_default_for
    expected = { :number => 1 }
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte').optional_param_defaults
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => nil).optional_param_defaults
  end

  def test_find_by_url_path
    assert_equal @tag_page, Staticpress::Content::Tag.find_by_url_path('/tag/charlotte')
  end

  def test_to_s
    assert_equal '#<Staticpress::Content::Tag url_path=/tag/charlotte, params={:name=>"charlotte", :number=>1}>', @tag_page.to_s
  end

  def test_sub_content
    assert_equal 1, @tag_page.sub_content.count
  end

  def test_raw
    assert_equal '= partial :list_posts, :posts => page.sub_content', @tag_page.raw
  end

  def test_url_path
    assert_equal '/tag/charlotte', @tag_page.url_path
  end

  def test_all
    assert_equal 1, Staticpress::Content::Tag.all.count
    assert Staticpress::Content::Tag.all.include?(@tag_page)
  end

  def test_content_by_tag
    [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
    ].each { |content| assert_includes Staticpress::Content::Tag.content_by_tag['charlotte'], content }
  end
end
