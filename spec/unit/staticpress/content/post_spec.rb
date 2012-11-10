require 'spec_helper'

describe Staticpress::Content::Post do
  include Staticpress::Helpers

  let(:post_dir) { Staticpress.blog_path + config.posts_source_path }

  let(:post) { Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello') }
  let(:another_post) { Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '20', :title => 'forever') }
  let(:long_title_post) { Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress') }

  describe '#<=>' do
    it '...' do
      expect(post).to be == another_post
      expect(another_post).to be == post
      expect([ post, another_post ].sort).to eq([ post, another_post ])
      expect([ another_post, post ].sort).to eq([ post, another_post ])
    end
  end

  describe '#created_at' do
    it '...' do
      expect(post.created_at).to eq(Time.utc(2011, 7, 20, 13, 9, 52))
      expect(another_post.created_at).to eq(Time.utc(2011, 8, 20))
    end
  end

  describe '#created_on' do
    it '...' do
      expect(post.created_on).to eq(Time.utc(2011, 7, 20))
      expect(another_post.created_on).to eq(Time.utc(2011, 8, 20))
    end
  end

  describe '.find_by_path' do
    it '...' do
      expect(Staticpress::Content::Post.find_by_path(post_dir + '2011-07-20-hello.markdown')).to eq(post)
      expect(Staticpress::Content::Post.find_by_path(post_dir + '2011-07-20-goodbye.markdown')).to be_nil
    end
  end

  describe '#template_path' do
    it '...' do
      expect(post.template_path).to eq(Staticpress.blog_path + config.posts_source_path + '2011-07-20-hello.markdown')
    end
  end

  describe '#title' do
    it '...' do
      expect(post.title).to eq('Hello, World')
      expect(long_title_post.title).to eq('Blogging With Staticpress')
    end
  end
end
