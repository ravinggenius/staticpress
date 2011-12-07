require_relative '../../test_case'

require 'staticpress/content/theme'
require 'staticpress/helpers'
require 'staticpress/route'

class ContentThemeTest < TestCase
  include Staticpress::Helpers

  let(:theme_dir) { Staticpress::Theme.theme.root }

  let(:asset_style) { Staticpress::Content::Theme.new :theme => 'test_theme', :asset_type => 'styles', :slug => 'all' }
  let(:asset_script) { Staticpress::Content::Theme.new :theme => 'test_theme', :asset_type => 'scripts', :slug => 'application.js' }

  def setup
    super
    config.theme = :test_theme
  end

  def test__equalsequals
    assert_operator asset_style, :==, Staticpress::Content::Theme.new(:theme => 'test_theme', :asset_type => 'styles', :slug => 'all')
    refute_operator asset_style, :==, nil
  end

  def test_all
    assert_equal 2, Staticpress::Content::Theme.all.count
  end

  def test_exist?
    assert asset_style.exist?, 'asset_style does not exist'
    assert asset_script.exist?, 'asset_script does not exist'
  end

  def test_find_by_path
    assert_equal asset_style, Staticpress::Content::Theme.find_by_path(theme_dir + 'assets' + 'styles' + 'all.sass')
    assert_nil Staticpress::Content::Theme.find_by_path(theme_dir + 'i' + 'dont' + 'exist.markdown')
    actual = Staticpress::Content::Theme.find_by_path(theme_dir + 'assets' + 'scripts' + 'application.js')
    assert_equal actual, asset_script
  end

  def test_find_by_url_path
    assert_equal asset_style, Staticpress::Content::Theme.find_by_url_path('/assets/test_theme/styles/all')
    assert_nil Staticpress::Content::Theme.find_by_url_path(nil)
    assert_equal asset_script, Staticpress::Content::Theme.find_by_url_path('/assets/test_theme/scripts/application.js')
  end

  def test_to_s
    assert_equal '#<Staticpress::Content::Theme url_path=/assets/test_theme/styles/all, params={:asset_type=>"styles", :slug=>"all", :theme=>"test_theme"}>', asset_style.to_s
  end

  def test_output_path
    assert_equal (Staticpress.blog_path + 'public' + 'assets' + 'test_theme' + 'styles' + 'all'), asset_style.output_path
    assert_equal (Staticpress.blog_path + 'public' + 'assets' + 'test_theme' + 'scripts' + 'application.js'), asset_script.output_path
  end

  def test_raw
    assert_equal '@import "compass/reset/utilities"', asset_style.raw
    expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
    JS
    assert_equal expected.strip, asset_script.raw
  end

  def test_render
    refute_raises(Sass::SyntaxError) { asset_style.render }
    expected = <<-SASS
    SASS
    assert_equal expected, asset_style.render
    expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
    JS
    assert_equal expected, asset_script.render
  end

  def test_render_partial
    refute_raises(Sass::SyntaxError) { asset_style.render_partial }
    expected = <<-SASS
    SASS
    assert_equal expected, asset_style.render_partial
    expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
    JS
    assert_equal expected, asset_script.render_partial
  end

  def test_url_path
    assert_equal '/assets/test_theme/styles/all', asset_style.url_path
  end

  def test_template_engine_options
    expected = Compass.sass_engine_options.merge :line_comments => false, :style => :compressed
    assert_eql expected, asset_style.template_engine_options
    assert_equal({}, asset_script.template_engine_options)
  end

  def test_template_type
    assert_equal :sass, asset_style.template_type
    assert_equal :js, asset_script.template_type
  end
end
