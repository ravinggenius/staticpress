require_relative 'base_test'

require 'octopress/content/post'

class ContentPostTest < ContentBaseTest
  def setup
    super
    @post = Octopress::Content::Post.new(READONLY + 'content' + '_posts' + '2011-07-20-hello.markdown')
  end

  def test__equalsequals
    assert_operator @post, :==, (Octopress::Content::Post.new(READONLY + 'content' + '_posts' + '2011-07-20-hello.markdown'))
    refute_operator @post, :==, (Octopress::Content::Post.new(READONLY + 'content' + '_posts' + '2011-07-20-goodbye.markdown'))
    refute_operator @post, :==, nil
  end

  def test_find_by_route
    assert_equal @post, Octopress::Content::Post.find_by_route(:year => '2011', :month => '07', :day => '20', :title => 'hello')
    assert_nil Octopress::Content::Post.find_by_route({})
  end
end
