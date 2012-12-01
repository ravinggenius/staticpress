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

  describe '#include_for' do
    it '...' do
      expect(theme.include_for(:list_posts)).to eq(theme.root + 'includes' + 'list_posts.haml')
      expect(theme.include_for(:fake)).to be_nil
    end
  end

  describe '#layout_for' do
    it '...' do
      expect(theme.layout_for(:default)).to eq(theme.root + 'layouts' + 'default.haml')
      expect(theme.layout_for(:post_index)).to eq(theme.root + 'layouts' + 'post_index.haml')
      expect(theme.layout_for(:fake)).to eq(theme.root + 'layouts' + 'default.haml')
    end
  end

  describe '#view_for' do
    it '...' do
      expect(theme.view_for(:default)).to eq(theme.root + 'views' + 'default.haml')
      expect(theme.view_for(:fake)).to eq(theme.root + 'views' + 'default.haml')
    end
  end
end
