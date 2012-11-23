require 'spec_helper'

describe Staticpress::Content::Page do
  include Staticpress::Helpers

  basic_blog

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

  describe '.all' do
    it '...' do
      expect(Staticpress::Content::Page.all.count).to eq(11)
    end
  end

  describe '#extension' do
    it '...' do
      expect(chained.template_extension).to eq('.markdown.erb')
      expect(chain.template_extension).to eq('.markdown.erb')
      expect(page.template_extension).to eq('.markdown')
    end
  end

  describe '#full_slug' do
    it '...' do
      expect(chained.full_slug).to eq('chained')
      expect(chain.full_slug).to eq('chain.html')
      expect(page.full_slug).to eq('about')
    end
  end

  describe '.extract_slug' do
    it '...' do
      expect(Staticpress::Content::Page.extract_slug(page_dir + 'chained.markdown.erb')).to eq('chained')
      expect(Staticpress::Content::Page.extract_slug(page_dir + 'about.markdown')).to eq('about')
      expect(Staticpress::Content::Page.extract_slug(page_dir + 'plain.txt')).to eq('plain.txt')
    end
  end

  describe '.find_by_path' do
    it '...' do
      expect(Staticpress::Content::Page.find_by_path(page_dir + 'chained.markdown.erb')).to eq(chained)
      expect(Staticpress::Content::Page.find_by_path(page_dir + 'chain.html.markdown.erb')).to eq(chain)
      expect(Staticpress::Content::Page.find_by_path(page_dir + 'about.markdown')).to eq(page)
      expect(Staticpress::Content::Page.find_by_path(page_dir + 'index.markdown')).to eq(index_page)
      expect(Staticpress::Content::Page.find_by_path(page_dir + 'i' + 'dont' + 'exist.markdown')).to be_nil
      expect(Staticpress::Content::Page.find_by_path(page_dir + 'ruby.png')).to eq(static_bin)
      expect(Staticpress::Content::Page.find_by_path(page_dir + 'i' + 'dont' + 'exist.jpg')).to be_nil
    end
  end

  describe '#template_path' do
    it '...' do
      expect(index_page.template_path).to eq(page_dir + 'index.markdown')
      expect(page.template_path).to eq(page_dir + 'about.markdown')
    end
  end
end
