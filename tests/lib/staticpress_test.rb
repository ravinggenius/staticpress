require_relative '../test_helper'

require 'pathname'

class StaticpressTest < TestHelper
  def test_blog_path
    assert_equal Pathname.new('.').expand_path, Staticpress.blog_path
    Staticpress.blog_path = 'tests/test_blog'
    assert_equal Pathname.new('tests/test_blog').expand_path, Staticpress.blog_path
  end

  def test_root
    assert_equal Pathname.new('lib/').expand_path, Staticpress.root
  end
end
