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

    @asset_route = Staticpress::Route.from_url_path '/assets/classic/styles/all'
    @asset = Staticpress::Content::Theme.new @asset_route, @theme_dir + 'assets' + 'styles' + 'all.sass'
  end

  def test__equalsequals
    assert_operator @asset, :==, Staticpress::Content::Theme.new(@asset_route, @theme_dir + 'assets' + 'styles' + 'all.sass')
    refute_operator @asset, :==, nil
  end

  def test_all
    assert_equal 1, Staticpress::Content::Theme.all.count
  end

  def test_exist?
    assert @asset.exist?, '@asset does not exist'
  end

  def test_find_by_path
    assert_equal @asset, Staticpress::Content::Theme.find_by_path(@theme_dir + 'assets' + 'styles' + 'all.sass')
    assert_nil Staticpress::Content::Theme.find_by_path(@theme_dir + 'i' + 'dont' + 'exist.markdown')
  end

  def test_find_by_route
    assert_equal @asset, Staticpress::Content::Theme.find_by_route(@asset_route)
    assert_nil Staticpress::Content::Theme.find_by_route(nil)
  end

  def test_inspect
    assert_equal '#<Staticpress::Content::Theme url_path=/assets/classic/styles/all>', @asset.inspect
  end

  def test_output_path
    assert_equal (Staticpress.blog_path + 'public' + 'assets' + 'classic' + 'styles' + 'all'), @asset.output_path
  end

  def test_raw
    expected = <<-SASS
    SASS
    assert_equal expected, @asset.raw
  end

  def test_render
    expected = <<-SASS
    SASS
    assert_equal expected, @asset.render
  end

  def test_render_partial
    expected = <<-SASS
    SASS
    assert_equal expected, @asset.render_partial
  end

  def test_route
    assert_equal '/assets/classic/styles/all', @asset.route.url_path
  end
end
