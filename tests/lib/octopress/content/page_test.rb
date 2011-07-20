require_relative 'base_test'

require 'octopress/content/page'

class ContentPageTest < ContentBaseTest
  def setup
    super
    @page = Octopress::Content::Page.new(READONLY + 'content' + 'about.markdown')
  end

  def test_equalsequals
    assert_equal @page, Octopress::Content::Page.new(READONLY + 'content' + 'about.markdown')
    refute_equal @page, Octopress::Content::Page.new(READONLY + 'content' + 'contact.markdown')
  end
end
