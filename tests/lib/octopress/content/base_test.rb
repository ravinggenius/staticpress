require_relative '../../../test_helper'

require 'octopress/content/base'

class ContentBaseTest < MiniTest::Unit::TestCase
  def setup
    @base = Octopress::Content::Base.new
  end
end
