require_relative '../../test_case'

require 'staticpress/content/index'
require 'staticpress/content/post'
require 'staticpress/helpers'

class ContentIndexTest < TestCase
  include Staticpress::Helpers

  let(:index) { Staticpress::Content::Index.new }

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
    end
  end
end
