require 'spec_helper'

describe Staticpress::Content::Post do
  include Staticpress::Helpers

  let(:post_dir) { Staticpress.blog_path + config.posts_source_path }

  let(:post) { Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello') }
  let(:another_post) { Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '20', :title => 'forever') }
  let(:long_title_post) { Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress') }

  def test__spaceship
    assert_operator post, :<=>, another_post
    assert_operator another_post, :<=>, post
    assert_equal [ post, another_post ], [ post, another_post ].sort
    assert_equal [ post, another_post ], [ another_post, post ].sort
  end

  def test_created_at
    assert_equal Time.utc(2011, 7, 20, 13, 9, 52), post.created_at
    assert_equal Time.utc(2011, 8, 20), another_post.created_at
  end

  def test_created_on
    assert_equal Time.utc(2011, 7, 20), post.created_on
    assert_equal Time.utc(2011, 8, 20), another_post.created_on
  end

  def test_find_by_path
    assert_equal post, Staticpress::Content::Post.find_by_path(post_dir + '2011-07-20-hello.markdown')
    assert_nil Staticpress::Content::Post.find_by_path(post_dir + '2011-07-20-goodbye.markdown')
  end

  def test_template_path
    assert_equal (Staticpress.blog_path + config.posts_source_path + '2011-07-20-hello.markdown'), post.template_path
  end

  def test_title
    assert_equal 'Hello, World', post.title
    assert_equal 'Blogging With Staticpress', long_title_post.title
  end
end
