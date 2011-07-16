require_relative '../../../test_helper'

class ContentPostTest < MiniTest::Unit::TestCase
  def setup
    @page = Octopress::Content::Post.new
  end
end
