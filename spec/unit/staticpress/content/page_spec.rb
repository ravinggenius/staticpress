require 'spec_helper'

describe Staticpress::Content::Page do
  include Staticpress::Helpers

  let(:page_dir) { Staticpress.blog_path + config.source_path }

  let(:chained) { Staticpress::Content::Page.new(:slug => 'chained') }
  let(:chain) { Staticpress::Content::Page.new(:slug => 'chain.html') }
  let(:page) { Staticpress::Content::Page.new :slug => 'about' }
  let(:second_page) { Staticpress::Content::Page.new :slug => 'contact' }
  let(:index_page) { Staticpress::Content::Page.new :slug => '' }
  let(:style2) { Staticpress::Content::Page.new :slug => 'style2.css' }
  let(:nested) { Staticpress::Content::Page.new :slug => 'foo/bar/baz' }
  let(:static_bin) { Staticpress::Content::Page.new :slug => 'ruby.png' }
  let(:static_txt) { Staticpress::Content::Page.new :slug => 'plain.txt' }

  let(:fake) { Staticpress::Content::Page.new :slug => 'i/dont/exist' }

  def test_all
    assert_equal 11, Staticpress::Content::Page.all.count
  end

  def test_extension
    assert_equal '.markdown.erb', chained.template_extension
    assert_equal '.markdown.erb', chain.template_extension
    assert_equal '.markdown', page.template_extension
  end

  def test_full_slug
    assert_equal 'chained', chained.full_slug
    assert_equal 'chain.html', chain.full_slug
    assert_equal 'about', page.full_slug
  end

  def test_extract_slug
    assert_equal 'chained', Staticpress::Content::Page.extract_slug(page_dir + 'chained.markdown.erb')
    assert_equal 'about', Staticpress::Content::Page.extract_slug(page_dir + 'about.markdown')
    assert_equal 'plain.txt', Staticpress::Content::Page.extract_slug(page_dir + 'plain.txt')
  end

  def test_find_by_path
    assert_equal chained, Staticpress::Content::Page.find_by_path(page_dir + 'chained.markdown.erb')
    assert_equal chain, Staticpress::Content::Page.find_by_path(page_dir + 'chain.html.markdown.erb')
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
