require_relative '../../../test_helper'

class ContentPageTest < MiniTest::Unit::TestCase
  def setup
    @page = Octopress::Content::Page.new
  end
end
