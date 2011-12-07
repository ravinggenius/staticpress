$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'compass'
require 'haml'
require 'minitest/autorun'
#require 'ruby-debug' # http://blog.wyeworks.com/2011/11/1/ruby-1-9-3-and-ruby-debug
require 'sass'

require 'staticpress'

class TestCase < MiniTest::Unit::TestCase
  SAMPLE_SITES = (Staticpress.root + '..' + 'tests' + 'sample_sites').expand_path
  TEST_BLOG = SAMPLE_SITES + 'test_blog'

  def setup
    Staticpress.blog_path = TEST_BLOG
  end

  def teardown
    Staticpress.blog_path = '.'
    test_blog_public = TEST_BLOG + 'public'
    FileUtils.rm_rf test_blog_public if test_blog_public.directory?
  end

  def env(path)
    {
      'REQUEST_PATH' => path
    }
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
