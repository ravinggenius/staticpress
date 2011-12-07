require_relative '../../test_case'

require 'staticpress/content/category'
require 'staticpress/route'
require 'staticpress/theme'

class ContentCategoryTest < TestCase
  let(:template_dir) { Staticpress::Theme.theme.root + 'views' }
  let(:category_page) { Staticpress::Content::Category.new :name => 'programming' }

  def test__equalsequals
    assert_operator category_page, :==, Staticpress::Content::Category.new(:name => 'programming')
    refute_operator category_page, :==, nil
  end

  def test_categories
    assert_equal [ 'programming', 'travel' ], Staticpress::Content::Category.categories
  end

  def test_exist?
    assert category_page.exist?, 'category_page does not exist'
  end

  def test_find_by_url_path
    assert_equal category_page, Staticpress::Content::Category.find_by_url_path('/category/programming')
  end

  def test_to_s
    assert_equal '#<Staticpress::Content::Category url_path=/category/programming, params={:name=>"programming", :number=>1}>', category_page.to_s
    assert_equal '#<Staticpress::Content::Category url_path=/category/programming, params={:name=>"programming", :number=>1}>', Staticpress::Content::Category.new(:name => 'programming', :number => nil).to_s
  end

  def test_sub_content
    assert_equal 3, category_page.sub_content.count
  end

  def test_raw
    assert_equal '= partial :list_posts, :posts => page.sub_content', category_page.raw
  end

  def test_url_path
    assert_equal '/category/programming', category_page.url_path
  end

  def test_all
    assert_equal 2, Staticpress::Content::Category.all.count
    assert Staticpress::Content::Category.all.include?(category_page)
  end

  def test_content_by_category
    [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '01', :title => 'announcing-staticpress'),
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '02', :title => 'staticpress'),
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress')
    ].each { |content| assert_includes Staticpress::Content::Category.content_by_category['programming'], content }
  end
end
