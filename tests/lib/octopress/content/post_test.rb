require_relative 'base_test'

require 'octopress/content/post'

class ContentPostTest < ContentBaseTest
  def setup
    super
    @post = Octopress::Content::Post.new(READONLY + 'content' + '_posts' + '2011-07-20-hello.markdown')
  end

  def test_equalsequals
    assert @post.==(Octopress::Content::Post.new(READONLY + 'content' + '_posts' + '2011-07-20-hello.markdown'))
    refute @post.==(Octopress::Content::Post.new(READONLY + 'content' + '_posts' + '2011-07-20-goodbye.markdown'))
  end
end
