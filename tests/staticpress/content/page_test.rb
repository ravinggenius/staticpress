require_relative 'base_test'

require 'staticpress/content/page'
require 'staticpress/helpers'

class ContentPageTest < ContentBaseTest
  include Staticpress::Helpers

  def setup
    super

    @page_dir = Staticpress.blog_path + config.source_path

    @page = Staticpress::Content::Page.new :slug => 'about'
    @second_page = Staticpress::Content::Page.new :slug => 'contact'
    @index_page = Staticpress::Content::Page.new :slug => ''
    @style2 = Staticpress::Content::Page.new :slug => 'style2.css'
    @nested = Staticpress::Content::Page.new :slug => 'foo/bar/baz'
    @static_bin = Staticpress::Content::Page.new :slug => 'ruby.png'
    @static_txt = Staticpress::Content::Page.new :slug => 'plain.txt'

    @fake = Staticpress::Content::Page.new :slug => 'i/dont/exist'
  end

  def test__equalsequals
    assert_operator @page, :==, Staticpress::Content::Page.new(:slug => 'about')
    refute_operator @page, :==, @second_page
    refute_operator @page, :==, nil
    assert_operator @static_bin, :==, Staticpress::Content::Page.new(:slug => 'ruby.png')
    refute_operator @static_bin, :==, nil
    refute_operator @static_bin, :==, @static_txt
  end

  def test_all
    assert_equal 9, Staticpress::Content::Page.all.count
  end

  def test_content_type
    assert_equal 'text/html', @page.content_type
    assert_equal 'text/css', @style2.content_type
    assert_equal 'image/png', @static_bin.content_type
    assert_equal 'text/plain', @static_txt.content_type
  end

  def test_exist?
    assert @page.exist?, "#{@page.inspect} does not exist"
    assert @second_page.exist?, "#{@second_page.inspect} does not exist"
    assert @static_bin.exist?, "#{@static_bin.inspect} does not exist"
    assert @static_txt.exist?, "#{@static_txt.inspect} does not exist"
    assert @index_page.exist?, "#{@index_page.inspect} does not exist"

    refute @fake.exist?, "#{@fake.inspect} exists"
  end

  def test_find_by_path
    assert_equal @page, Staticpress::Content::Page.find_by_path(@page_dir + 'about.markdown')
    assert_nil Staticpress::Content::Page.find_by_path(@page_dir + 'i' + 'dont' + 'exist.markdown')
    assert_equal @static_bin, Staticpress::Content::Page.find_by_path(@page_dir + 'ruby.png')
    assert_nil Staticpress::Content::Page.find_by_path(@page_dir + 'i' + 'dont' + 'exist.jpg')
  end

  def test_find_by_url_path
    assert_equal @index_page, Staticpress::Content::Page.find_by_url_path('/')
    assert_equal @page, Staticpress::Content::Page.find_by_url_path('/about')
    assert_equal @static_bin, Staticpress::Content::Page.find_by_url_path('/ruby.png')
    assert_nil Staticpress::Content::Page.find_by_url_path(nil)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Page url_path=/, params={:slug=>""}>', @index_page.inspect
    assert_equal '#<Staticpress::Content::Page url_path=/about, params={:slug=>"about"}>', @page.inspect
    assert_equal '#<Staticpress::Content::Page url_path=/ruby.png, params={:slug=>"ruby.png"}>', @static_bin.inspect
  end

  def test_output_path
    assert_equal (Staticpress.blog_path + 'public' + 'about' + 'index.html'), @page.output_path
    assert_equal (Staticpress.blog_path + 'public' + 'index.html'), @index_page.output_path
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

  def test_url_path
    assert_equal '/', @index_page.url_path
    assert_equal '/about', @page.url_path
    assert_equal '/contact', @second_page.url_path
    assert_equal '/ruby.png', @static_bin.url_path
    assert_equal '/plain.txt', @static_txt.url_path
  end

  def test_save
    @static_bin.save
    assert_equal @static_bin.template_path.binread, @static_bin.output_path.binread

    @static_txt.save
    assert_equal @static_txt.template_path.read, @static_txt.output_path.read
  end

  def test_template_path
    assert_equal @page_dir + 'index.markdown', @index_page.template_path
    assert_equal @page_dir + 'about.markdown', @page.template_path
  end

  def test_template_type
    assert_equal :markdown, @page.template_type
  end

  def test_full_title
    assert_equal 'Foo -> Bar -> Baz | Test Blog', @nested.full_title
  end

  def test_title
    assert_equal 'Foo -> Bar -> Baz', @nested.title
  end
end
