require_relative 'base_test'

require 'staticpress/content/theme'
require 'staticpress/helpers'
require 'staticpress/route'

class ContentThemeTest < ContentBaseTest
  include Staticpress::Helpers

  def setup
    super

    Staticpress::Content::Theme.all

    @theme_dir = Staticpress::Theme.theme.root

    @asset_style_route = Staticpress::Route.from_url_path '/assets/classic/styles/all'
    @asset_style = Staticpress::Content::Theme.new @asset_style_route, @theme_dir + 'assets' + 'styles' + 'all.sass'

    @asset_script_route = Staticpress::Route.from_url_path '/assets/classic/scripts/application.js'
    @asset_script = Staticpress::Content::Theme.new @asset_script_route, @theme_dir + 'assets' + 'scripts' + 'application.js'
  end

  def test__equalsequals
    assert_operator @asset_style, :==, Staticpress::Content::Theme.new(@asset_style_route, @theme_dir + 'assets' + 'styles' + 'all.sass')
    refute_operator @asset_style, :==, nil
  end

  def test_all
    assert_equal 2, Staticpress::Content::Theme.all.count
  end

  def test_exist?
    assert @asset_style.exist?, '@asset_style does not exist'
    assert @asset_script.exist?, '@asset_script does not exist'
  end

  def test_find_by_path
    assert_equal @asset_style, Staticpress::Content::Theme.find_by_path(@theme_dir + 'assets' + 'styles' + 'all.sass')
    assert_nil Staticpress::Content::Theme.find_by_path(@theme_dir + 'i' + 'dont' + 'exist.markdown')
    path = (@theme_dir + 'assets' + 'scripts' + 'application.js')
    actual = Staticpress::Content::Theme.find_by_path(@theme_dir + 'assets' + 'scripts' + 'application.js')
    assert_equal @asset_script, actual
  end

  def test_find_by_route
    assert_equal @asset_style, Staticpress::Content::Theme.find_by_route(@asset_style_route)
    assert_nil Staticpress::Content::Theme.find_by_route(nil)
    assert_equal @asset_script, Staticpress::Content::Theme.find_by_route(@asset_script_route)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Theme url_path=/assets/classic/styles/all>', @asset_style.inspect
  end

  def test_output_path
    assert_equal (Staticpress.blog_path + 'public' + 'assets' + 'classic' + 'styles' + 'all'), @asset_style.output_path
    assert_equal (Staticpress.blog_path + 'public' + 'assets' + 'classic' + 'scripts' + 'application.js'), @asset_script.output_path
  end

  def test_raw
    expected = <<-SASS
    SASS
    assert_equal expected, @asset_style.raw
    expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
    JS
    assert_equal expected.strip, @asset_script.raw
  end

  def test_render
    expected = <<-SASS
    SASS
    assert_equal expected, @asset_style.render
    expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
    JS
    assert_equal expected, @asset_script.render
  end

  def test_render_partial
    expected = <<-SASS
    SASS
    assert_equal expected, @asset_style.render_partial
    expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
    JS
    assert_equal expected, @asset_script.render_partial
  end

  def test_route
    assert_equal '/assets/classic/styles/all', @asset_style.route.url_path
  end
end
