require_relative '../../../test_helper'

class ContentBaseTest < MiniTest::Unit::TestCase
  def setup
    @base = Octopress::Content::Base.new
  end
end
