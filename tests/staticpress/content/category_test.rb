require_relative '../../test_case'

require 'staticpress/content/category'
require 'staticpress/content/post'

class ContentCategoryTest < TestCase
  let(:category) { Staticpress::Content::Category.new :name => 'programming' }

  def test_categories
    assert_equal [ 'programming', 'travel' ], Staticpress::Content::Category.categories
  end

  def test_sub_content
    assert_equal 3, category.sub_content.count
  end

  def test_all
    assert_equal 2, Staticpress::Content::Category.all.count
    assert Staticpress::Content::Category.all.include?(category)
  end

  def test_content_by_category
    [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '01', :title => 'announcing-staticpress'),
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '02', :title => 'staticpress'),
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress')
    ].each { |content| assert_includes Staticpress::Content::Category.content_by_category['programming'], content }
  end
end
