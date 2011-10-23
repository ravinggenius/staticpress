$:.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'ruby-debug'

require 'staticpress'

class TestHelper < MiniTest::Unit::TestCase
  SAMPLE_SITES = (Staticpress.root + '..' + 'tests' + 'sample_sites').expand_path
  TEST_BLOG = SAMPLE_SITES + 'test_blog'

  def teardown
    Staticpress.blog_path = '.'
    test_blog_public = TEST_BLOG + 'public'
    FileUtils.rm_rf test_blog_public if test_blog_public.directory?
  end
end
