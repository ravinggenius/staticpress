require_relative '../../../test_helper'

require 'octopress/content/base'

class ContentBaseTest < MiniTest::Unit::TestCase
  READONLY = SAMPLE_SITES + 'readonly'

  def setup
    Octopress.blog_path = READONLY
  end

  def teardown
    Octopress.blog_path = '.'
  end
end
