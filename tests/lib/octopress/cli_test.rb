require_relative '../../test_helper'

require 'fileutils'
require 'pathname'

require 'octopress'
require 'octopress/cli'
require 'octopress/helpers'

class CLITest < MiniTest::Unit::TestCase
  include Octopress::Helpers

  TEST_BLOG = (Octopress.root + '..' + 'tests' + 'blog').expand_path

  def setup
    Octopress.blog_path = TEST_BLOG
    @cli = Octopress::CLI.new
  end

  def teardown
    FileUtils.rm_rf TEST_BLOG if TEST_BLOG.directory?
    Octopress.blog_path = '.'
  end

  def test_help
  end

  def test_new
    refute TEST_BLOG.directory?
    @cli.new TEST_BLOG
    assert_equal 5, TEST_BLOG.children.count
    refute_empty config.title
  end

  def test_new_with_custom_title
    @cli.new TEST_BLOG, 'This is my blog'
    assert_equal 'This is my blog', config.title
  end

  def test_create
  end

  def test_create_page
  end

  def test_fork_plugin
  end

  def test_fork_theme
  end

  def test_build
  end

  def test_serve
  end

  def test_push
  end

  def test_deploy
  end

  def test_version
  end
end
