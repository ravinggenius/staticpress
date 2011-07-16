require_relative '../../test_helper'

require 'octopress/theme'

class ThemeTest < MiniTest::Unit::TestCase
  def setup
    @theme = Octopress::Theme.new :classic
  end
end
