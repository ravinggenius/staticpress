require 'spec_helper'

describe Staticpress::Theme do
  include Staticpress::Helpers

  basic_blog

  let(:theme) { Staticpress::Theme.new :test_theme }

  before :each do
    config.theme = :test_theme
  end

  describe '#==' do
    it '...' do
      expect(Staticpress::Theme.new(:test_theme)).to be == theme
    end
  end

  describe '#root' do
    it '...' do
      expect(Staticpress.blog_path + 'themes' + 'test_theme').to eq(theme.root)
    end
  end

  describe '#theme' do
    it '...' do
      expect(Staticpress::Theme.theme).to eq(theme)
    end
  end


  describe '#default_include' do
    it '...' do
      expect(theme).to_not respond_to(:default_include)
    end
  end

  describe '#keyed_includes' do
    it '...' do
      expect(theme.keyed_includes['list_posts']).to eq(theme.root + 'includes' + 'list_posts.haml')
      expect(theme.keyed_includes['fake']).to be_nil
    end
  end

  describe '#include_for' do
    it '...' do
      expect(theme.include_for(:list_posts)).to eq(theme.root + 'includes' + 'list_posts.haml')
      expect(theme.include_for(:fake)).to be_nil
    end
  end

  describe '#includes' do
    it '...' do
      expect(theme.includes.count).to eq(1)
    end
  end


  describe '#default_layout' do
    it '...' do
      expect(theme.default_layout).to eq(theme.root + 'layouts' + 'default.haml')
    end
  end

  describe '#keyed_layouts' do
    it '...' do
      expect(theme.keyed_layouts['default']).to eq(theme.root + 'layouts' + 'default.haml')
      expect(theme.keyed_layouts['post_index']).to eq(theme.root + 'layouts' + 'post_index.haml')
      expect(theme.keyed_layouts['fake']).to be_nil
    end
  end

  describe '#layout_for' do
    it '...' do
      expect(theme.layout_for(:default)).to eq(theme.root + 'layouts' + 'default.haml')
      expect(theme.layout_for(:post_index)).to eq(theme.root + 'layouts' + 'post_index.haml')
      expect(theme.layout_for(:fake)).to be_nil
    end
  end

  describe '#layouts' do
    it '...' do
      expect(theme.layouts.count).to eq(5)
    end
  end


  describe '#default_view' do
    it '...' do
      expect(theme.default_view).to eq(theme.root + 'views' + 'default.haml')
    end
  end

  describe '#keyed_views' do
    it '...' do
      expect(theme.keyed_views['default']).to eq(theme.root + 'views' + 'default.haml')
      expect(theme.keyed_views['fake']).to be_nil
    end
  end

  describe '#view_for' do
    it '...' do
      expect(theme.view_for(:default)).to eq(theme.root + 'views' + 'default.haml')
      expect(theme.view_for(:fake)).to be_nil
    end
  end

  describe '#views' do
    it '...' do
      expect(theme.views.count).to eq(1)
    end
  end
end
