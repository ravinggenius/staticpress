require_relative 'base_test'

require 'staticpress/content/page'
require 'staticpress/helpers'
require 'staticpress/route'

class ContentPageTest < ContentBaseTest
  include Staticpress::Helpers

  def setup
    super

    @page_dir = Staticpress.blog_path + config.source_path

    @page_route = Staticpress::Route.from_url_path '/about'
    @page = Staticpress::Content::Page.new @page_route, @page_dir + 'about.markdown'

    @second_page_route = Staticpress::Route.from_url_path '/contact'
    @second_page = Staticpress::Content::Page.new @second_page_route, @page_dir + 'contact.markdown'

    @style2_route = Staticpress::Route.from_url_path '/style2.css'
    @style2 = Staticpress::Content::Page.new @style2_route, @page_dir + 'style2.css.sass'

    @nested_route = Staticpress::Route.from_url_path '/foo/bar/baz'
    @nested = Staticpress::Content::Page.new @nested_route, @page_dir + 'foo' + 'bar' + 'baz'

    @static_bin_route = Staticpress::Route.from_url_path '/ruby.png'
    @static_bin = Staticpress::Content::Page.new @static_bin_route, @page_dir + 'ruby.png'

    @static_txt_route = Staticpress::Route.from_url_path '/plain.txt'
    @static_txt = Staticpress::Content::Page.new @static_txt_route, @page_dir + 'plain.txt'
  end

  def test__equalsequals
    assert_operator @page, :==, Staticpress::Content::Page.new(@page_route, @page_dir + 'about.markdown')
    refute_operator @page, :==, @second_page
    refute_operator @page, :==, nil
    assert_operator @static_bin, :==, Staticpress::Content::Page.new(@static_bin_route, @page_dir + 'ruby.png')
    refute_operator @static_bin, :==, nil
    refute_operator @static_bin, :==, @static_txt
  end

  def test_all
    assert_equal 8, Staticpress::Content::Page.all.count
  end

  def test_exist?
    assert @page.exist?, '@page does not exist'
    assert @second_page.exist?, '@second_page does not exist'
    assert @static_bin.exist?, '@static_bin does not exist'
    assert @static_txt.exist?, '@static_txt does not exist'
  end

  def test_find_by_path
    @page_dir = Staticpress.blog_path + config.source_path
    assert_equal @page, Staticpress::Content::Page.find_by_path(@page_dir + 'about.markdown')
    assert_nil Staticpress::Content::Page.find_by_path(@page_dir + 'i' + 'dont' + 'exist.markdown')
    assert_equal @static_bin, Staticpress::Content::Page.find_by_path(@page_dir + 'ruby.png')
    assert_nil Staticpress::Content::Page.find_by_path(@page_dir + 'i' + 'dont' + 'exist.jpg')
  end

  def test_find_by_route
    assert_equal @page, Staticpress::Content::Page.find_by_route(@page_route)
    assert_nil Staticpress::Content::Page.find_by_route(nil)
    assert_equal @static_bin, Staticpress::Content::Page.find_by_route(@static_bin_route)
    assert_nil Staticpress::Content::Page.find_by_route(nil)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Page url_path=/about>', @page.inspect
    assert_equal '#<Staticpress::Content::Page url_path=/ruby.png>', @static_bin.inspect
  end

  def test_output_path
    assert_equal (Staticpress.blog_path + 'public' + 'about' + 'index.html'), @page.output_path
    assert_equal (Staticpress.blog_path + 'public' + 'style2.css'), @style2.output_path
    assert_equal (Staticpress.blog_path + 'public' + 'ruby.png'), @static_bin.output_path
    assert_equal (Staticpress.blog_path + 'public' + 'plain.txt'), @static_txt.output_path
  end

  def test_raw
    assert_equal 'in page', @page.raw
    assert_equal "in page\n\nin page", @second_page.raw
    assert_equal 'this file intentionally left blank', @static_txt.raw
  end

  def test_render
    expected_page = <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <title>About | Test Blog</title>
  </head>
  <body>
    <p>in page</p>
  </body>
</html>
    HTML
    assert_equal expected_page, @page.render

    expected_style2 = <<-CSS
body{color:green}
    CSS
    assert_equal expected_style2, @style2.render
    assert_equal 'this file intentionally left blank', @static_txt.render
  end

  def test_render_partial
    assert_equal "<p>in page</p>\n", @page.render_partial
    assert_equal "<p>in page</p>\n\n<p>in page</p>\n", @second_page.render_partial
    expected_style2 = <<-CSS
body{color:green}
    CSS
    assert_equal expected_style2, @style2.render_partial
    assert_equal 'this file intentionally left blank', @static_txt.render_partial
  end

  def test_route
    assert_equal '/about', @page.route.url_path
    assert_equal '/contact', @second_page.route.url_path
    assert_equal '/ruby.png', @static_bin.route.url_path
    assert_equal '/plain.txt', @static_txt.route.url_path
  end

  def test_save
    @static_bin.save
    assert_equal @static_bin.template_path.binread, @static_bin.output_path.binread

    @static_txt.save
    assert_equal @static_txt.template_path.read, @static_txt.output_path.read
  end

  def test_full_title
    assert_equal 'Foo -> Bar -> Baz | Test Blog', @nested.full_title
  end

  def test_title
    assert_equal 'Foo -> Bar -> Baz', @nested.title
  end
end
