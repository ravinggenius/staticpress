require_relative '../../test_helper'

require 'staticpress/helpers'
require 'staticpress/theme'

class ThemeTest < TestHelper
  include Staticpress::Helpers

  def setup
    Staticpress.blog_path = TEST_BLOG
    config.theme = :test_theme
    @theme = Staticpress::Theme.new :test_theme
  end

  def test__equalsequals
    assert_operator @theme, :==, Staticpress::Theme.new(:test_theme)
  end

  def test_root
    assert_equal @theme.root, (Staticpress.blog_path + 'themes' + 'test_theme')
  end

  def test_theme
    assert_equal @theme, Staticpress::Theme.theme
  end


  def test_default_include
    refute_respond_to @theme, :default_include
  end

  def test_keyed_includes
    assert_equal((@theme.root + 'includes' + 'list_posts.haml'), @theme.keyed_includes['list_posts'])
    assert_nil @theme.keyed_includes['fake']
  end

  def test_include_for
    assert_equal (@theme.root + 'includes' + 'list_posts.haml'), @theme.include_for(:list_posts)
    assert_nil @theme.include_for(:fake)
  end

  def test_includes
    assert_equal 1, @theme.includes.count
  end


  def test_default_layout
    assert_equal (@theme.root + 'layouts' + 'default.haml'), @theme.default_layout
  end

  def test_keyed_layouts
    assert_equal((@theme.root + 'layouts' + 'default.haml'), @theme.keyed_layouts['default'])
    assert_equal((@theme.root + 'layouts' + 'post_index.haml'), @theme.keyed_layouts['post_index'])
    assert_nil @theme.keyed_layouts['fake']
  end

  def test_layout_for
    assert_equal (@theme.root + 'layouts' + 'default.haml'), @theme.layout_for(:default)
    assert_equal (@theme.root + 'layouts' + 'post_index.haml'), @theme.layout_for(:post_index)
    assert_nil @theme.layout_for(:fake)
  end

  def test_layouts
    assert_equal 5, @theme.layouts.count
  end


  def test_default_view
    assert_equal (@theme.root + 'views' + 'default.haml'), @theme.default_view
  end

  def test_keyed_views
    assert_equal((@theme.root + 'views' + 'default.haml'), @theme.keyed_views['default'])
    assert_nil @theme.keyed_views['fake']
  end

  def test_view_for
    assert_equal (@theme.root + 'views' + 'default.haml'), @theme.view_for(:default)
    assert_nil @theme.view_for(:fake)
  end

  def test_views
    assert_equal 1, @theme.views.count
  end
end
