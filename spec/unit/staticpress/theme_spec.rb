require 'spec_helper'

describe Staticpress::Theme do
  include Staticpress::Helpers

  basic_blog

  let(:parent) { Staticpress::Theme.new :test_theme_parent }
  let(:theme) { Staticpress::Theme.new :test_theme }

  before :each do
    config.theme = :test_theme
  end

  describe '#==' do
    it '...' do
      expect(Staticpress::Theme.new(:test_theme)).to be == theme
    end
  end

  describe '#assets' do
    it 'finds all files in the asset directory, top-level or nested' do
      assets = theme.assets
      expect(assets.count).to eq(2)
      expect(assets).to include(theme.root + 'assets' + 'scripts' + 'application.js')
      expect(assets).to include(theme.root + 'assets' + 'styles' + 'all.sass')
    end

    context 'inherit from another theme' do
      before :each do
        theme.copy_to :test_theme_parent
        (theme.root + 'assets' + 'scripts' + 'application.js').delete
      end

      it 'finds all files in parent theme along with own files' do
        with_config :theme_parent => :test_theme_parent do
          assets = theme.assets
          expect(assets.count).to eq(3)
          expect(assets).to include(parent.root + 'assets' + 'scripts' + 'application.js')
          expect(assets).to include(parent.root + 'assets' + 'styles' + 'all.sass')
          expect(assets).to include(theme.root + 'assets' + 'styles' + 'all.sass')
        end
      end
    end
  end

  describe '#root' do
    it '...' do
      expect(Staticpress.blog_path + 'themes' + 'test_theme').to eq(theme.root)
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

  describe '.theme' do
    it '...' do
      expect(Staticpress::Theme.theme).to eq(theme)
    end
  end
end
