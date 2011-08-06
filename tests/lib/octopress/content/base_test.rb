require_relative '../../../test_helper'

require 'octopress/content/base'
require 'octopress/content/page'
require 'octopress/content/post'

class ContentBaseTest < TestHelper
  def setup
    Octopress.blog_path = TEST_BLOG
  end

  def test_content_types
    content_types = Octopress::Content::Base.content_types
    [
      Octopress::Content::Page,
      Octopress::Content::Post
    ].each do |expected|
      assert_includes content_types, expected
    end
  end
end
