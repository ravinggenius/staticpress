require_relative '../../test_helper'

require 'fileutils'
require 'pathname'

require 'staticpress/cli'
require 'staticpress/helpers'

class CLITest < TestHelper
  include Staticpress::Helpers

  def setup
    Staticpress.blog_path = TEMP_BLOG
    @cli = Staticpress::CLI.new
  end

  def teardown
    FileUtils.rm_rf TEMP_BLOG if TEMP_BLOG.directory?
    super
  end

  # FIXME breaks ContentThemeTest#test_template_engine_options
  def _test_new
    refute TEMP_BLOG.directory?
    @cli.new TEMP_BLOG
    assert_equal 4, TEMP_BLOG.children.count
    assert_equal 'Temp Blog', config.title
  end

  # FIXME breaks ContentThemeTest#test_template_engine_options
  def _test_new_with_custom_title
    @cli.new TEMP_BLOG, 'This is my blog'
    assert_equal 'This is my blog', config.title
  end
end
