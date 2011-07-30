require_relative '../../../test_helper'

require 'octopress/content/base'
require 'octopress/content/page'
require 'octopress/content/post'

class ContentBaseTest < TestHelper
  def setup
    Octopress.blog_path = READONLY
  end

  def test_content_types
    assert_includes Octopress::Content::Base.content_types, Octopress::Content::Page
    assert_includes Octopress::Content::Base.content_types, Octopress::Content::Post
  end
end
