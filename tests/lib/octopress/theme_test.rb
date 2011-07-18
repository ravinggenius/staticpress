require_relative '../../test_helper'

require 'octopress/theme'

class ThemeTest < MiniTest::Unit::TestCase
  def setup
    @theme = Octopress::Theme.new :classic
  end

  def test_layout_for
    assert_equal (@theme.root + '_layouts' + 'default.haml'), @theme.layout_for(:default)
  end

  def test_keyed_layouts
  end

  def test_layouts
  end
end
