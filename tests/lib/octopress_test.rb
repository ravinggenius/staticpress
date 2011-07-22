require_relative '../test_helper'

require 'pathname'

class OctopressTest < TestHelper
  def test_blog_path
    assert_equal Pathname.new('.').expand_path, Octopress.blog_path
    Octopress.blog_path = 'tests/test_blog'
    assert_equal Pathname.new('tests/test_blog').expand_path, Octopress.blog_path
  end

  def test_root
    assert_equal Pathname.new('lib/').expand_path, Octopress.root
  end
end
