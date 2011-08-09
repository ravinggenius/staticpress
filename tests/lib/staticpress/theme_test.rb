require_relative '../../test_helper'

require 'staticpress/theme'

class ThemeTest < TestHelper
  def setup
    @theme = Staticpress::Theme.new :classic
  end

  def test_layout_for
    assert_equal (@theme.root + '_layouts' + 'default.haml'), @theme.layout_for(:default)
  end

  def test_keyed_layouts
    assert_equal({ 'default' => (@theme.root + '_layouts' + 'default.haml') }, @theme.keyed_layouts)
  end

  def test_layouts
    assert_equal 1, @theme.layouts.count
  end
end
