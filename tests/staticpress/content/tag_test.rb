require_relative '../../test_case'

require 'staticpress/content/post'
require 'staticpress/content/tag'

class ContentTagTest < TestCase
  let(:tag) { Staticpress::Content::Tag.new :name => 'charlotte' }

  def test_tags
    assert_equal [ 'charlotte' ], Staticpress::Content::Tag.tags
  end

  def test_pages_count
    assert_equal 1, tag.pages_count
  end

  def test_optional_param_defaults
    expected = { :number => 1 }
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte').optional_param_defaults
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => nil).optional_param_defaults
  end

  def test_sub_content
    expected = [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
    ]
    assert_equal expected, tag.sub_content
  end

  def test_all
    assert_equal 1, Staticpress::Content::Tag.all.count
    assert Staticpress::Content::Tag.all.include?(tag)
  end

  def test_content_by_tag
    [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
    ].each { |content| assert_includes Staticpress::Content::Tag.content_by_tag['charlotte'], content }
  end
end
