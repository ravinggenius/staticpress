require_relative '../../test_case'

require 'staticpress/content/page'
require 'staticpress/helpers'

class ContentPageTest < TestCase
  include Staticpress::Helpers

  let(:page_dir) { Staticpress.blog_path + config.source_path }

  let(:page) { Staticpress::Content::Page.new :slug => 'about' }
  let(:second_page) { Staticpress::Content::Page.new :slug => 'contact' }
  let(:index_page) { Staticpress::Content::Page.new :slug => '' }
  let(:style2) { Staticpress::Content::Page.new :slug => 'style2.css' }
  let(:nested) { Staticpress::Content::Page.new :slug => 'foo/bar/baz' }
  let(:static_bin) { Staticpress::Content::Page.new :slug => 'ruby.png' }
  let(:static_txt) { Staticpress::Content::Page.new :slug => 'plain.txt' }

  let(:fake) { Staticpress::Content::Page.new :slug => 'i/dont/exist' }

  def test_all
    assert_equal 9, Staticpress::Content::Page.all.count
  end

  def test_find_by_path
    assert_equal page, Staticpress::Content::Page.find_by_path(page_dir + 'about.markdown')
    assert_equal index_page, Staticpress::Content::Page.find_by_path(page_dir + 'index.markdown')
    assert_nil Staticpress::Content::Page.find_by_path(page_dir + 'i' + 'dont' + 'exist.markdown')
    assert_equal static_bin, Staticpress::Content::Page.find_by_path(page_dir + 'ruby.png')
    assert_nil Staticpress::Content::Page.find_by_path(page_dir + 'i' + 'dont' + 'exist.jpg')
  end

  def test_template_path
    assert_equal page_dir + 'index.markdown', index_page.template_path
    assert_equal page_dir + 'about.markdown', page.template_path
  end
end
