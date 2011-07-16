require_relative '../../../test_helper'

class ContentBaseTest < MiniTest::Unit::TestCase
  def setup
    @page = Octopress::Content::Base.new
  end
end
