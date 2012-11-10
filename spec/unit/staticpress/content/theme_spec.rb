require 'spec_helper'

describe Staticpress::Content::Theme do
  include Staticpress::Helpers

  let(:theme_dir) { Staticpress::Theme.theme.root }

  let(:asset_style) { Staticpress::Content::Theme.new :theme => 'test_theme', :asset_type => 'styles', :slug => 'all' }
  let(:asset_script) { Staticpress::Content::Theme.new :theme => 'test_theme', :asset_type => 'scripts', :slug => 'application.js' }

  def setup
    super
    config.theme = :test_theme
  end

  def test_all
    assert_equal 2, Staticpress::Content::Theme.all.count
  end

  def test_find_by_path
    assert_equal asset_style, Staticpress::Content::Theme.find_by_path(theme_dir + 'assets' + 'styles' + 'all.sass')
    assert_nil Staticpress::Content::Theme.find_by_path(theme_dir + 'i' + 'dont' + 'exist.markdown')
    actual = Staticpress::Content::Theme.find_by_path(theme_dir + 'assets' + 'scripts' + 'application.js')
    assert_equal actual, asset_script
  end
end
