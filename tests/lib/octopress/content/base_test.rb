require_relative '../../../test_helper'

require 'octopress/content/base'
require 'octopress/content/page'
require 'octopress/content/post'

class ContentBaseTest < TestHelper
  def setup
    Octopress.blog_path = READONLY
  end

  def test_content_types
    content_types = Octopress::Content::Base.content_types
    assert_equal 2, content_types.length
    assert_includes content_types, Octopress::Content::Page
    assert_includes content_types, Octopress::Content::Post
  end
end
