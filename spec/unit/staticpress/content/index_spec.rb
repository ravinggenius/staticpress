require 'spec_helper'

describe Staticpress::Content::Index do
  include Staticpress::Helpers

  let(:index) { Staticpress::Content::Index.new }
  let(:unpublished) { Staticpress::Content::Post.new(:year => '2012', :month => '09', :day => '19', :title => 'unpublished') }

  def test_pages_count
    assert_equal 1, index.pages_count

    with_config :posts_per_page => 2 do
      assert_equal 4, index.pages_count
    end
  end

  def test_sub_content
    with_config :posts_per_page => 4 do
      # expect three most recent posts with oldest on top (index is lazy-evaluated)
      expected = [
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'conferences'),
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress'),
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '20', :title => 'forever')
      ]
      assert_equal expected, index.sub_content
      refute_includes index.sub_content, unpublished
    end
  end

  def test_all
    with_config :posts_per_page => 3 do
      expected = [
        Staticpress::Content::Index.new(:number => 1),
        Staticpress::Content::Index.new(:number => 2),
        Staticpress::Content::Index.new(:number => 3)
      ]
      assert_equal expected, Staticpress::Content::Index.all
    end
  end
end
