require_relative '../../test_helper'

require 'octopress/theme'

class ThemeTest < MiniTest::Unit::TestCase
  def setup
    @theme = Octopress::Theme.new :classic
  end

  def test_extensionless_basename
    assert_equal '.htaccess', @theme.extensionless_basename(Pathname.new('.htaccess'))
    assert_equal 'tyrannasaurus_rex', @theme.extensionless_basename(Pathname.new('tyrannasaurus_rex.rb'))
  end
end
