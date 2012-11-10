require 'spec_helper'

describe Staticpress::Theme do
  include Staticpress::Helpers

  let(:theme) { Staticpress::Theme.new :test_theme }

  before :each do
    config.theme = :test_theme
  end

  describe '#==' do
    it '...' do
      assert_operator theme, :==, Staticpress::Theme.new(:test_theme)
    end
  end

  describe '#root' do
    it '...' do
      assert_equal theme.root, (Staticpress.blog_path + 'themes' + 'test_theme')
    end
  end

  describe '#theme' do
    it '...' do
      assert_equal theme, Staticpress::Theme.theme
    end
  end


  describe '#default_include' do
    it '...' do
      refute_respond_to theme, :default_include
    end
  end

  describe '#keyed_includes' do
    it '...' do
      assert_equal((theme.root + 'includes' + 'list_posts.haml'), theme.keyed_includes['list_posts'])
      assert_nil theme.keyed_includes['fake']
    end
  end

  describe '#include_for' do
    it '...' do
      assert_equal (theme.root + 'includes' + 'list_posts.haml'), theme.include_for(:list_posts)
      assert_nil theme.include_for(:fake)
    end
  end

  describe '#includes' do
    it '...' do
      assert_equal 1, theme.includes.count
    end
  end


  describe '#default_layout' do
    it '...' do
      assert_equal (theme.root + 'layouts' + 'default.haml'), theme.default_layout
    end
  end

  describe '#keyed_layouts' do
    it '...' do
      assert_equal((theme.root + 'layouts' + 'default.haml'), theme.keyed_layouts['default'])
      assert_equal((theme.root + 'layouts' + 'post_index.haml'), theme.keyed_layouts['post_index'])
      assert_nil theme.keyed_layouts['fake']
    end
  end

  describe '#layout_for' do
    it '...' do
      assert_equal (theme.root + 'layouts' + 'default.haml'), theme.layout_for(:default)
      assert_equal (theme.root + 'layouts' + 'post_index.haml'), theme.layout_for(:post_index)
      assert_nil theme.layout_for(:fake)
    end
  end

  describe '#layouts' do
    it '...' do
      assert_equal 5, theme.layouts.count
    end
  end


  describe '#default_view' do
    it '...' do
      assert_equal (theme.root + 'views' + 'default.haml'), theme.default_view
    end
  end

  describe '#keyed_views' do
    it '...' do
      assert_equal((theme.root + 'views' + 'default.haml'), theme.keyed_views['default'])
      assert_nil theme.keyed_views['fake']
    end
  end

  describe '#view_for' do
    it '...' do
      assert_equal (theme.root + 'views' + 'default.haml'), theme.view_for(:default)
      assert_nil theme.view_for(:fake)
    end
  end

  describe '#views' do
    it '...' do
      assert_equal 1, theme.views.count
    end
  end
end
