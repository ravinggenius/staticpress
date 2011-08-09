require_relative '../../../test_helper'

require 'staticpress/content/base'

class ContentBaseTest < TestHelper
  def setup
    Staticpress.blog_path = TEST_BLOG
  end
end
