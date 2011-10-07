require_relative 'base_test'

require 'staticpress/content/page'
require 'staticpress/helpers'
require 'staticpress/route'

class ContentPageTest < ContentBaseTest
  include Staticpress::Helpers

  def setup
    super

    @page_dir = Staticpress.blog_path + config.source

    @page_route = Staticpress::Route.from_url_path '/about'
    @page = Staticpress::Content::Page.new @page_route, @page_dir + 'about.markdown'

    @second_page_route = Staticpress::Route.from_url_path '/contact'
    @second_page = Staticpress::Content::Page.new @second_page_route, @page_dir + 'contact.markdown'
  end

  def test__equalsequals
    assert_operator @page, :==, Staticpress::Content::Page.new(@page_route, @page_dir + 'about.markdown')
    refute_operator @page, :==, @second_page
    refute_operator @page, :==, nil
  end

  def test_all
    assert_equal 2, Staticpress::Content::Page.all.count
  end

  def test_exist?
    assert @page.exist?, '@page does not exist'
    assert @second_page.exist?, '@second_page does not exist'
  end

  def test_find_by_path
    @page_dir = Staticpress.blog_path + config.source
    assert_equal @page, Staticpress::Content::Page.find_by_path(@page_dir + 'about.markdown')
    assert_nil Staticpress::Content::Page.find_by_path(@page_dir + 'i' + 'dont' + 'exist.markdown')
  end

  def test_find_by_route
    assert_equal @page, Staticpress::Content::Page.find_by_route(@page_route)
    assert_nil Staticpress::Content::Page.find_by_route(nil)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Page url_path=/about>', @page.inspect
  end

  def test_output_path
    assert_equal (Staticpress.blog_path + 'public' + 'about' + 'index.html'), @page.output_path
  end

  def test_raw
    assert_equal 'in page', @page.raw
    assert_equal "in page\n\nin page", @second_page.raw
  end

  def test_render
    expected_page = <<-HTML
<html>
  <head>
    <title>/about</title>
  </head>
  <body>
    <p>in page</p>
  </body>
</html>
    HTML
    assert_equal expected_page, @page.render
  end

  def test_render_partial
    assert_equal "<p>in page</p>\n", @page.render_partial
    assert_equal "<p>in page</p>\n\n<p>in page</p>\n", @second_page.render_partial
  end

  def test_route
    assert_equal '/about', @page.route.url_path
    assert_equal '/contact', @second_page.route.url_path
  end
end
