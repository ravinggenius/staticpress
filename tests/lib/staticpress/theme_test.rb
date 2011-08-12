require_relative '../../test_helper'

require 'staticpress/theme'

class ThemeTest < TestHelper
  def setup
    @theme = Staticpress::Theme.new :classic
  end

  def test_default_layout
    assert_equal (@theme.root + '_layouts' + 'default.haml'), @theme.default_layout
  end

  def test_keyed_layouts
    assert_equal((@theme.root + '_layouts' + 'default.haml'), @theme.keyed_layouts['default'])
    assert_equal((@theme.root + '_layouts' + 'post_index.haml'), @theme.keyed_layouts['post_index'])
    assert_nil @theme.keyed_layouts['fake']
  end

  def test_layout_for
    assert_equal (@theme.root + '_layouts' + 'default.haml'), @theme.layout_for(:default)
    assert_equal (@theme.root + '_layouts' + 'post_index.haml'), @theme.layout_for(:post_index)
    assert_equal (@theme.root + '_layouts' + 'default.haml'), @theme.layout_for(:fake)
  end

  def test_layouts
    assert_equal 2, @theme.layouts.count
  end
end
