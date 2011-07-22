$:.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'

require 'octopress'

class TestHelper < MiniTest::Unit::TestCase
  SAMPLE_SITES = (Octopress.root + '..' + 'tests' + 'sample_sites').expand_path
  READONLY = SAMPLE_SITES + 'readonly'

  def teardown
    Octopress.blog_path = '.'
  end
end
