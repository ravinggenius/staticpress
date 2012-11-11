require 'spec_helper'

describe Staticpress::Site do
  set_temporary_blog_path

  let(:site) { Staticpress::Site.new }

  let(:index) { Staticpress::Content::Page.new :slug => '' }
  let(:page) { Staticpress::Content::Page.new :slug => 'about' }
  let(:post) { Staticpress::Content::Post.new :year => '2011', :month => '07', :day => '20', :title => 'hello' }

  describe '.find_content_by_env' do
    it '...' do
      expect(site.find_content_by_env(env('/'))).to eq(index)
      expect(site.find_content_by_env(env('/about'))).to eq(page)
      expect(site.find_content_by_env(env('/2011/07/20/hello'))).to eq(post)
      expect(site.find_content_by_env(env('/i/dont/exist'))).to be_nil
    end
  end

  describe '#save' do
    it '...' do
      expect { site.save }.to_not raise_error(ArgumentError)
    end
  end
end
