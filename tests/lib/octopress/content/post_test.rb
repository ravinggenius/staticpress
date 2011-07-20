require_relative 'base_test'

require 'octopress/content/post'

class ContentPostTest < ContentBaseTest
  def setup
    @post = Octopress::Content::Post.new
  end
end
