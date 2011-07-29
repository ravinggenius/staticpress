require_relative 'base_test'

require 'octopress/content/page'

class ContentPageTest < ContentBaseTest
  def setup
    super
    @page = Octopress::Content::Page.new(READONLY + 'content' + 'about.markdown')
    @second_page = Octopress::Content::Page.new(READONLY + 'content' + 'contact.markdown')
  end

  def test__equalsequals
    assert_operator @page, :==, (Octopress::Content::Page.new(READONLY + 'content' + 'about.markdown'))
    refute_operator @page, :==, (Octopress::Content::Page.new(READONLY + 'content' + 'contact.markdown'))
    refute_operator @page, :==, nil
  end

  def test_raw
    assert_equal 'in page', @page.raw
    assert_equal "in page\n\nin page", @second_page.raw
  end

  def test_route
    assert_equal '/about', @page.route
    assert_equal '/contact', @second_page.route
  end
end
