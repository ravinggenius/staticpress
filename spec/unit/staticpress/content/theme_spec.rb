require 'spec_helper'

describe Staticpress::Content::Theme do
  include Staticpress::Helpers

  set_temporary_blog_path

  let(:theme_dir) { Staticpress::Theme.theme.root }

  let(:asset_style) { Staticpress::Content::Theme.new :theme => 'test_theme', :asset_type => 'styles', :slug => 'all' }
  let(:asset_script) { Staticpress::Content::Theme.new :theme => 'test_theme', :asset_type => 'scripts', :slug => 'application.js' }

  before :each do
    config.theme = :test_theme
  end

  describe '.all' do
    it 'finds all the theme content' do
      expect(Staticpress::Content::Theme.all.count).to eq(2)
    end
  end

  describe '.find_by_path' do
    it 'finds content when given a path' do
      expect(Staticpress::Content::Theme.find_by_path(theme_dir + 'assets' + 'styles' + 'all.sass')).to eq(asset_style)
      expect(Staticpress::Content::Theme.find_by_path(theme_dir + 'i' + 'dont' + 'exist.markdown')).to be_nil
      actual = Staticpress::Content::Theme.find_by_path(theme_dir + 'assets' + 'scripts' + 'application.js')
      expect(asset_script).to eq(actual)
    end
  end
end
