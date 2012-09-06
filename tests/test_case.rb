$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'compass'
require 'debugger'
require 'haml'
require 'minitest/autorun'
require 'redcarpet'
require 'sass'

require 'staticpress'

class TestCase < MiniTest::Spec
  TEST_BLOG = (Staticpress.root + '..' + 'tests' + 'test_blog').expand_path

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
      refute e.is_an?(exception), exception_details(e, "Expected #{e} not to be raised")
      raise e
    end
  end

  def with_config(options, &block)
    original = self.config

    begin
      self.config.merge(options).save
      block.call
    ensure
      original.save
    end
  end
end
