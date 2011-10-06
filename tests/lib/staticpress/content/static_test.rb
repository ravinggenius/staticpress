require_relative 'base_test'

require 'staticpress/content/static'
require 'staticpress/helpers'
require 'staticpress/route'

class ContentStaticTest < ContentBaseTest
  include Staticpress::Helpers

  def setup
    super

    @static_dir = Staticpress.blog_path + config.source

    @static_route = Staticpress::Route.from_url_path '/ruby.png'
    @static = Staticpress::Content::Static.new @static_route, @static_dir + 'ruby.png'
  end

  def test__equalsequals
    assert_operator @static, :==, Staticpress::Content::Static.new(@static_route, @static_dir + 'ruby.png')
    refute_operator @static, :==, nil
  end

  def test_exist?
    assert @static.exist?, '@static does not exist'
  end

  def test_find_by_path
    assert_equal @static, Staticpress::Content::Static.find_by_path(@static_dir + 'ruby.png')
    assert_nil Staticpress::Content::Static.find_by_path(@static_dir + 'i' + 'dont' + 'exist.jpg')
  end

  def test_find_by_route
    assert_equal @static, Staticpress::Content::Static.find_by_route(@static_route)
    assert_nil Staticpress::Content::Static.find_by_route(nil)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Static url_path=/ruby.png>', @static.inspect
  end

  def test_raw
  end

  def test_render_partial
  end

  def test_route
    assert_equal '/ruby.png', @static.route.url_path
  end
end
