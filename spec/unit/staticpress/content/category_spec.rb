require 'spec_helper'

describe Staticpress::Content::Category do
  include Staticpress::Helpers

  let(:category) { Staticpress::Content::Category.new :name => 'programming' }

  describe '.categories' do
    assert_equal [ 'programming', 'travel' ], Staticpress::Content::Category.categories
  end

  describe '#pages_count' do
    assert_equal 1, category.pages_count

    with_config :posts_per_page => 2 do
      assert_equal 2, category.pages_count
    end
  end

  describe '#sub_content' do
    expected = [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '01', :title => 'announcing-staticpress'),
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '02', :title => 'staticpress'),
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress')
    ]
    assert_equal expected, category.sub_content
  end

  describe '.all' do
    with_config :posts_per_page => 1 do
      expected = [
        Staticpress::Content::Category.new(:name => 'programming', :number => 1),
        Staticpress::Content::Category.new(:name => 'programming', :number => 2),
        Staticpress::Content::Category.new(:name => 'programming', :number => 3),
        Staticpress::Content::Category.new(:name => 'travel', :number => 1)
      ]
      assert_equal expected, Staticpress::Content::Category.all
    end
  end

  describe '.content_by_category' do
    [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '01', :title => 'announcing-staticpress'),
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '02', :title => 'staticpress'),
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress')
    ].each { |content| assert_includes Staticpress::Content::Category.content_by_category['programming'], content }
  end
end
