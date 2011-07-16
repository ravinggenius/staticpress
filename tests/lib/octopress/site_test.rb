require_relative '../../test_helper'

class SiteTest < MiniTest::Unit::TestCase
  def setup
    @site = Octopress::Site.new
  end
end
