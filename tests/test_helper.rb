$:.unshift File.expand_path('../../lib', __FILE__)

require 'compass'
require 'haml'
require 'minitest/autorun'
require 'ruby-debug'
require 'sass'

require 'staticpress'

class TestHelper < MiniTest::Unit::TestCase
  SAMPLE_SITES = (Staticpress.root + '..' + 'tests' + 'sample_sites').expand_path
  TEST_BLOG = SAMPLE_SITES + 'test_blog'

  def teardown
    Staticpress.blog_path = '.'
    test_blog_public = TEST_BLOG + 'public'
    FileUtils.rm_rf test_blog_public if test_blog_public.directory?
  end

  def assert_eql(expected, actual, message = nil)
    assert actual.eql?(expected), (message || "Expected #{actual} to have same content as #{expected}")
  end

  def refute_raises(exception, &block)
    begin
      block.call
      assert true
    rescue Exception => e
      # TODO improve error message
      refute e.class == exception, "#{exception} expected not to be raised, but was"
      raise e
    end
  end
end
