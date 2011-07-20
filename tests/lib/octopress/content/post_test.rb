require_relative 'base_test'

class ContentPostTest < ContentBaseTest
  def setup
    @post = Octopress::Content::Post.new
  end
end
