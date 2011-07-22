require_relative '../../../test_helper'

require 'octopress/content/base'

class ContentBaseTest < TestHelper
  def setup
    Octopress.blog_path = READONLY
  end
end
