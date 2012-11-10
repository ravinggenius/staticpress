require 'spec_helper'

describe Staticpress::Content::Base do
  let(:category) { Staticpress::Content::Category.new :name => 'programming' }
  let(:category_1) { Staticpress::Content::Category.new(:name => 'programming', :number => '1') }
  let(:category_2) { Staticpress::Content::Category.new(:name => 'programming', :number => '2') }

  let(:index) { Staticpress::Content::Index.new }
  let(:index_2) { Staticpress::Content::Index.new :number => 2 }

  let(:chained) { Staticpress::Content::Page.new(:slug => 'chained') }
  let(:chain) { Staticpress::Content::Page.new(:slug => 'chain.html') }
  let(:page) { Staticpress::Content::Page.new(:slug => 'about') }
  let(:second_page) { Staticpress::Content::Page.new :slug => 'contact' }
  let(:page_root) { Staticpress::Content::Page.new :slug => '' }
  let(:style_2) { Staticpress::Content::Page.new :slug => 'style2.css' }
  let(:page_nested) { Staticpress::Content::Page.new :slug => 'foo/bar/baz' }
  let(:static_bin) { Staticpress::Content::Page.new :slug => 'ruby.png' }
  let(:static_txt) { Staticpress::Content::Page.new :slug => 'plain.txt' }
  let(:page_fake) { Staticpress::Content::Page.new :slug => 'i/dont/exist' }

  let(:post) { Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello') }
  let(:unpublished) { Staticpress::Content::Post.new(:year => '2012', :month => '09', :day => '19', :title => 'unpublished') }

  let(:tag) { Staticpress::Content::Tag.new :name => 'charlotte' }

  let(:asset_style) { Staticpress::Content::Theme.new :theme => 'test_theme', :asset_type => 'styles', :slug => 'all' }
  let(:asset_script) { Staticpress::Content::Theme.new :theme => 'test_theme', :asset_type => 'scripts', :slug => 'application.js' }

  describe '#==' do
    assert_operator category, :==, Staticpress::Content::Category.new(:name => 'programming')
    refute_operator category, :==, nil

    assert_operator index, :==, Staticpress::Content::Index.new(:number => 1)
    refute_operator index, :==, index_2
    refute_operator index, :==, nil

    assert_operator page, :==, Staticpress::Content::Page.new(:slug => 'about')
    refute_operator page, :==, second_page
    refute_operator page, :==, nil
    assert_operator static_bin, :==, Staticpress::Content::Page.new(:slug => 'ruby.png')
    refute_operator static_bin, :==, nil
    refute_operator static_bin, :==, static_txt

    assert_operator post, :==, Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello')
    refute_operator post, :==, nil

    assert_operator tag, :==, Staticpress::Content::Tag.new(:name => 'charlotte')
    refute_operator tag, :==, nil

    assert_operator asset_style, :==, Staticpress::Content::Theme.new(:theme => 'test_theme', :asset_type => 'styles', :slug => 'all')
    refute_operator asset_style, :==, nil

    refute_operator Staticpress::Content::Category.new(:name => 'programming'), :==, Staticpress::Content::Tag.new(:name => 'programming')
    refute_operator Staticpress::Content::Tag.new(:name => 'charlotte'), :==, Staticpress::Content::Category.new(:name => 'charlotte')
  end

  describe '#content_type' do
    assert_equal 'text/html', chained.content_type
    assert_equal 'text/html', page.content_type
    assert_equal 'text/css', style_2.content_type
    assert_equal 'image/png', static_bin.content_type
    assert_equal 'text/plain', static_txt.content_type
  end

  describe '#exist?' do
    assert category.exist?, "#{category} does not exist"
    assert index.exist?, "#{index} does not exist"

    assert chained.exist?, "#{chained} does not exist"
    assert chain.exist?, "#{chain} does not exist"
    assert page.exist?, "#{page} does not exist"
    assert second_page.exist?, "#{second_page} does not exist"
    assert static_bin.exist?, "#{static_bin} does not exist"
    assert static_txt.exist?, "#{static_txt} does not exist"
    assert page_root.exist?, "#{page_root} does not exist"

    assert post.exist?, "#{post} does not exist"
    assert unpublished.exist?, "#{unpublished} does not exist"
    assert tag.exist?, "#{tag} does not exist"

    assert asset_style.exist?, "#{asset_style} does not exist"
    assert asset_script.exist?, "#{asset_script} does not exist"

    refute page_fake.exist?, "#{page_fake} exists"
  end

  describe '.find_by_url_path' do
    assert_equal category, Staticpress::Content::Category.find_by_url_path('/category/programming')
    assert_equal index, Staticpress::Content::Index.find_by_url_path('/')

    assert_equal page_root, Staticpress::Content::Page.find_by_url_path('/')
    assert_equal chained, Staticpress::Content::Page.find_by_url_path('/chained')
    assert_equal page, Staticpress::Content::Page.find_by_url_path('/about')
    assert_equal static_bin, Staticpress::Content::Page.find_by_url_path('/ruby.png')

    assert_equal post, Staticpress::Content::Post.find_by_url_path('/2011/07/20/hello')
    assert_equal tag, Staticpress::Content::Tag.find_by_url_path('/tag/charlotte')

    assert_equal asset_style, Staticpress::Content::Theme.find_by_url_path('/assets/test_theme/styles/all')
    assert_equal asset_script, Staticpress::Content::Theme.find_by_url_path('/assets/test_theme/scripts/application.js')

    assert_nil Staticpress::Content::Theme.find_by_url_path(nil)
  end

  describe '#full_title' do
    assert_equal 'Foo -> Bar -> Baz | Test Blog', page_nested.full_title
  end

  describe '#markup_template?' do
    assert chained.markup_template?, "#{chained} is not markup"
    assert chain.markup_template?, "#{chain} is not markup"
    assert page.markup_template?, "#{page} is not markup"

    refute style_2.markup_template?, "#{chained} is markup"
  end

  describe '#output_path' do
    output_directory = Staticpress.blog_path + 'public'
    assert_equal (output_directory + 'chained' + 'index.html'), chained.output_path
    assert_equal (output_directory + 'chain.html'), chain.output_path
    assert_equal (output_directory + 'about' + 'index.html'), page.output_path
    assert_equal (output_directory + 'index.html'), page_root.output_path
    assert_equal (output_directory + 'style2.css'), style_2.output_path
    assert_equal (output_directory + 'ruby.png'), static_bin.output_path
    assert_equal (output_directory + 'plain.txt'), static_txt.output_path
    assert_equal (output_directory + '2011' + '07' + '20' + 'hello' + 'index.html'), post.output_path
    assert_equal (output_directory + 'assets' + 'test_theme' + 'styles' + 'all'), asset_style.output_path
    assert_equal (output_directory + 'assets' + 'test_theme' + 'scripts' + 'application.js'), asset_script.output_path
  end

  describe '#params' do
    expected = { :name => 'charlotte', :number => 1 }
    assert_equal expected, tag.params
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => nil).params
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => 1).params
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => '1').params

    assert_equal({ :slug => 'chain.html' }, Staticpress::Content::Page.new(:slug => 'chain.html').params)
  end

  describe '#raw' do
    assert_equal '= partial :list_posts, :posts => page.sub_content', category.raw

    assert_equal "<%= 'Processed with ERB' %>, then Markdown.", chained.raw
    assert_equal 'in page', page.raw
    assert_equal "in page\n\nin page", second_page.raw
    assert_equal 'this file intentionally left blank', static_txt.raw

    assert_equal 'in post', post.raw
    assert_equal '= partial :list_posts, :posts => page.sub_content', tag.raw
    assert_equal '@import "compass/reset/utilities"', asset_style.raw

    expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
    JS
    assert_equal expected.strip, asset_script.raw
  end

  describe '#render' do
    expected_page = <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <title>About | Test Blog</title>
  </head>
  <body>
    <p>in page</p>
  </body>
</html>
    HTML
    assert_equal expected_page, page.render

    expected_style2 = <<-CSS
body{color:green}
    CSS
    assert_equal expected_style2, style_2.render

    assert_equal 'this file intentionally left blank', static_txt.render
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

  describe '#render_partial' do
    assert_equal "<p>Processed with ERB, then Markdown.</p>\n", chained.render_partial
    assert_equal "<p>in page</p>\n", page.render_partial
    assert_equal "<p>in page</p>\n\n<p>in page</p>\n", second_page.render_partial

    expected_style2 = <<-CSS
body{color:green}
    CSS
    assert_equal expected_style2, style_2.render_partial

    assert_equal 'this file intentionally left blank', static_txt.render_partial
    assert_equal "<p>in post</p>\n", post.render_partial

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

  describe '#save' do
    static_bin.save
    assert_equal static_bin.template_path.binread, static_bin.output_path.binread

    static_txt.save
    assert_equal static_txt.template_path.read, static_txt.output_path.read
  end

  describe '#template_engine_options' do
    refute asset_script.template_engine_options(:sass)[:line_comments]
    assert_equal :compressed, asset_script.template_engine_options(:sass)[:style]
    assert_equal({}, asset_script.template_engine_options(:js))
  end

  describe '#template_types' do
    assert_equal [:erb, :markdown], chained.template_types
    assert_equal [:erb, :markdown], chain.template_types
    assert_equal [:markdown], page.template_types
    assert_equal [:sass], asset_style.template_types
    assert_equal [], asset_script.template_types
  end

  describe '#title' do
    assert_equal 'Foo -> Bar -> Baz', page_nested.title
  end

  describe '#to_s' do
    assert_equal '#<Staticpress::Content::Category url_path=/category/programming, params={:name=>"programming", :number=>1}>', category.to_s
    assert_equal '#<Staticpress::Content::Category url_path=/category/programming, params={:name=>"programming", :number=>1}>', Staticpress::Content::Category.new(:name => 'programming', :number => nil).to_s

    assert_equal '#<Staticpress::Content::Index url_path=/, params={:number=>1}>', index.to_s
    assert_equal '#<Staticpress::Content::Index url_path=/page/2, params={:number=>2}>', index_2.to_s

    assert_equal '#<Staticpress::Content::Page url_path=/, params={:slug=>""}>', page_root.to_s
    assert_equal '#<Staticpress::Content::Page url_path=/about, params={:slug=>"about"}>', page.to_s
    assert_equal '#<Staticpress::Content::Page url_path=/ruby.png, params={:slug=>"ruby.png"}>', static_bin.to_s

    assert_equal '#<Staticpress::Content::Post url_path=/2011/07/20/hello, params={:day=>"20", :month=>"07", :title=>"hello", :year=>"2011"}>', post.to_s

    assert_equal '#<Staticpress::Content::Tag url_path=/tag/charlotte, params={:name=>"charlotte", :number=>1}>', tag.to_s

    assert_equal '#<Staticpress::Content::Theme url_path=/assets/test_theme/styles/all, params={:asset_type=>"styles", :slug=>"all", :theme=>"test_theme"}>', asset_style.to_s
  end

  describe '#url_path' do
    assert_equal '/category/programming', category.url_path
    assert_equal '/category/programming', category_1.url_path
    assert_equal '/category/programming/page/2', category_2.url_path

    assert_equal '/', index.url_path
    assert_equal '/page/2', index_2.url_path

    assert_equal '/', page_root.url_path
    assert_equal '/chained', chained.url_path
    assert_equal '/chain.html', chain.url_path
    assert_equal '/about', page.url_path
    assert_equal '/contact', second_page.url_path
    assert_equal '/ruby.png', static_bin.url_path
    assert_equal '/plain.txt', static_txt.url_path

    assert_equal '/2011/07/20/hello', post.url_path

    assert_equal '/2011/07/20/hello', post.url_path
    assert_equal '/tag/charlotte', tag.url_path
    assert_equal '/assets/test_theme/styles/all', asset_style.url_path
  end
end
