require_relative 'base_test'

require 'staticpress/content/static'
require 'staticpress/error'
require 'staticpress/helpers'
require 'staticpress/route'

class ContentStaticTest < ContentBaseTest
  include Staticpress::Helpers

  def setup
    super

    @static_dir = Staticpress.blog_path + config.source

    @static_bin_route = Staticpress::Route.from_url_path '/ruby.png'
    @static_bin = Staticpress::Content::Static.new @static_bin_route, @static_dir + 'ruby.png'

    @static_txt_route = Staticpress::Route.from_url_path '/plain.txt'
    @static_txt = Staticpress::Content::Static.new @static_txt_route, @static_dir + 'plain.txt'
  end

  def test__equalsequals
    assert_operator @static_bin, :==, Staticpress::Content::Static.new(@static_bin_route, @static_dir + 'ruby.png')
    refute_operator @static_bin, :==, nil
    refute_operator @static_bin, :==, @static_txt
  end

  def test_exist?
    assert @static_bin.exist?, '@static_bin does not exist'
    assert @static_txt.exist?, '@static_txt does not exist'
  end

  def test_find_by_path
    assert_equal @static_bin, Staticpress::Content::Static.find_by_path(@static_dir + 'ruby.png')
    assert_nil Staticpress::Content::Static.find_by_path(@static_dir + 'i' + 'dont' + 'exist.jpg')
  end

  def test_find_by_route
    assert_equal @static_bin, Staticpress::Content::Static.find_by_route(@static_bin_route)
    assert_nil Staticpress::Content::Static.find_by_route(nil)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Static url_path=/ruby.png>', @static_bin.inspect
  end

  def test_raw
    assert_equal 'this file intentionally left blank', @static_txt.raw
  end

  def test_render_partial
    assert_raises Staticpress::Error do
      @static_txt.render_partial
    end
  end

  def test_route
    assert_equal '/ruby.png', @static_bin.route.url_path
    assert_equal '/plain.txt', @static_txt.route.url_path
  end
end
