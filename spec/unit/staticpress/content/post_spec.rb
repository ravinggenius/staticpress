require 'spec_helper'

describe Staticpress::Content::Post do
  include Staticpress::Helpers

  let(:post_dir) { Staticpress.blog_path + config.posts_source_path }

  let(:post) { Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello') }
  let(:another_post) { Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '20', :title => 'forever') }
  let(:long_title_post) { Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress') }

  describe '#<=>' do
    assert_operator post, :<=>, another_post
    assert_operator another_post, :<=>, post
    assert_equal [ post, another_post ], [ post, another_post ].sort
    assert_equal [ post, another_post ], [ another_post, post ].sort
  end

  describe '#created_at' do
    assert_equal Time.utc(2011, 7, 20, 13, 9, 52), post.created_at
    assert_equal Time.utc(2011, 8, 20), another_post.created_at
  end

  describe '#created_on' do
    assert_equal Time.utc(2011, 7, 20), post.created_on
    assert_equal Time.utc(2011, 8, 20), another_post.created_on
  end

  describe '.find_by_path' do
    assert_equal post, Staticpress::Content::Post.find_by_path(post_dir + '2011-07-20-hello.markdown')
    assert_nil Staticpress::Content::Post.find_by_path(post_dir + '2011-07-20-goodbye.markdown')
  end

  describe '#template_path' do
    assert_equal (Staticpress.blog_path + config.posts_source_path + '2011-07-20-hello.markdown'), post.template_path
  end

  describe '#title' do
    assert_equal 'Hello, World', post.title
    assert_equal 'Blogging With Staticpress', long_title_post.title
  end
end
