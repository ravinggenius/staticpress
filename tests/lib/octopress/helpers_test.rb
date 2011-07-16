require_relative '../../test_helper'

require 'octopress/helpers'

class HelpersTest < MiniTest::Unit::TestCase
  include Octopress::Helpers

  def test_extensionless_basename
    assert_equal '.htaccess', extensionless_basename(Pathname.new('.htaccess'))
    assert_equal 'tyrannasaurus_rex', extensionless_basename(Pathname.new('tyrannasaurus_rex.rb'))
    assert_equal 'extensionless', extensionless_basename(Pathname.new('extensionless'))
  end

  def test_route_options
  end
end
