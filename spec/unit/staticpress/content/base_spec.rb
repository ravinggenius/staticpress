require 'spec_helper'

describe Staticpress::Content::Base do
  basic_blog

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
    it '...' do
      expect(category).to be == Staticpress::Content::Category.new(:name => 'programming')
      expect(category).to_not be == nil

      expect(index).to be == Staticpress::Content::Index.new(:number => 1)
      expect(index).to_not be == index_2
      expect(index).to_not be == nil

      expect(page).to be == Staticpress::Content::Page.new(:slug => 'about')
      expect(page).to_not be == second_page
      expect(page).to_not be == nil
      expect(static_bin).to be == Staticpress::Content::Page.new(:slug => 'ruby.png')
      expect(static_bin).to_not be == nil
      expect(static_bin).to_not be == static_txt

      expect(post).to be == Staticpress::Content::Post.new(:year => '2011', :month => '07', :day => '20', :title => 'hello')
      expect(post).to_not be == nil

      expect(tag).to be == Staticpress::Content::Tag.new(:name => 'charlotte')
      expect(tag).to_not be == nil

      expect(asset_style).to be == Staticpress::Content::Theme.new(:theme => 'test_theme', :asset_type => 'styles', :slug => 'all')
      expect(asset_style).to_not be == nil

      expect(Staticpress::Content::Category.new(:name => 'programming')).to_not be == Staticpress::Content::Tag.new(:name => 'programming')
      expect(Staticpress::Content::Tag.new(:name => 'charlotte')).to_not be == Staticpress::Content::Category.new(:name => 'charlotte')
    end
  end

  describe '#content_type' do
    it '...' do
      expect(chained.content_type).to eq('text/html')
      expect(page.content_type).to eq('text/html')
      expect(style_2.content_type).to eq('text/css')
      expect(static_bin.content_type).to eq('image/png')
      expect(static_txt.content_type).to eq('text/plain')
    end
  end

  describe '#exist?' do
    it '...' do
      expect(category).to exist
      expect(index).to exist

      expect(chained).to exist
      expect(chain).to exist
      expect(page).to exist
      expect(second_page).to exist
      expect(static_bin).to exist
      expect(static_txt).to exist
      expect(page_root).to exist

      expect(post).to exist
      expect(unpublished).to exist
      expect(tag).to exist

      expect(asset_style).to exist
      expect(asset_script).to exist

      expect(page_fake).to_not exist
    end
  end

  describe '.find_by_url_path' do
    it '...' do
      expect(Staticpress::Content::Category.find_by_url_path('/category/programming')).to eq(category)
      expect(Staticpress::Content::Index.find_by_url_path('/')).to eq(index)

      expect(Staticpress::Content::Page.find_by_url_path('/')).to eq(page_root)
      expect(Staticpress::Content::Page.find_by_url_path('/chained')).to eq(chained)
      expect(Staticpress::Content::Page.find_by_url_path('/about')).to eq(page)
      expect(Staticpress::Content::Page.find_by_url_path('/ruby.png')).to eq(static_bin)

      expect(Staticpress::Content::Post.find_by_url_path('/2011/07/20/hello')).to eq(post)
      expect(Staticpress::Content::Tag.find_by_url_path('/tag/charlotte')).to eq(tag)

      expect(Staticpress::Content::Theme.find_by_url_path('/assets/test_theme/styles/all')).to eq(asset_style)
      expect(Staticpress::Content::Theme.find_by_url_path('/assets/test_theme/scripts/application.js')).to eq(asset_script)

      expect(Staticpress::Content::Theme.find_by_url_path(nil)).to be_nil
    end
  end

  describe '#full_title' do
    it '...' do
      expect(page_nested.full_title).to eq('Foo -> Bar -> Baz | Test Blog')
    end
  end

  describe '#markup_template?' do
    it '...' do
      expect(chained.markup_template?).to be_true
      expect(chain.markup_template?).to be_true
      expect(page.markup_template?).to be_true

      expect(style_2.markup_template?).to be_false
    end
  end

  describe '#output_path' do
    it '...' do
      output_directory = Staticpress.blog_path + 'public'
      expect(chained.output_path).to eq(output_directory + 'chained' + 'index.html')
      expect(chain.output_path).to eq(output_directory + 'chain.html')
      expect(page.output_path).to eq(output_directory + 'about' + 'index.html')
      expect(page_root.output_path).to eq(output_directory + 'index.html')
      expect(style_2.output_path).to eq(output_directory + 'style2.css')
      expect(static_bin.output_path).to eq(output_directory + 'ruby.png')
      expect(static_txt.output_path).to eq(output_directory + 'plain.txt')
      expect(post.output_path).to eq(output_directory + '2011' + '07' + '20' + 'hello' + 'index.html')
      expect(asset_style.output_path).to eq(output_directory + 'assets' + 'test_theme' + 'styles' + 'all')
      expect(asset_script.output_path).to eq(output_directory + 'assets' + 'test_theme' + 'scripts' + 'application.js')
    end
  end

  describe '#params' do
    it '...' do
      expected = { :name => 'charlotte', :number => 1 }
      expect(tag.params).to eq(expected)
      expect(Staticpress::Content::Tag.new(:name => 'charlotte', :number => nil).params).to eq(expected)
      expect(Staticpress::Content::Tag.new(:name => 'charlotte', :number => 1).params).to eq(expected)
      expect(Staticpress::Content::Tag.new(:name => 'charlotte', :number => '1').params).to eq(expected)

      expect(Staticpress::Content::Page.new(:slug => 'chain.html').params).to eq(:slug => 'chain.html')
    end
  end

  describe '#raw' do
    it '...' do
      expect(category.raw).to eq('= partial :list_posts, :posts => page.sub_content')

      expect(chained.raw).to eq("<%= 'Processed with ERB' %>, then Markdown.")
      expect(page.raw).to eq('in page')
      expect(second_page.raw).to eq("in page\n\nin page")
      expect(static_txt.raw).to eq('this file intentionally left blank')

      expect(post.raw).to eq('in post')
      expect(tag.raw).to eq('= partial :list_posts, :posts => page.sub_content')
      expect(asset_style.raw).to eq('@import "compass/reset/utilities"')

      expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
      JS
      expect(asset_script.raw).to eq(expected.strip)
    end
  end

  describe '#render' do
    it '...' do
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
      expect(page.render).to eq(expected_page)

      expected_style2 = <<-CSS
body{color:green}
      CSS
      expect(style_2.render).to eq(expected_style2)

      expect(static_txt.render).to eq('this file intentionally left blank')
      expect { asset_style.render }.to_not raise_error(Sass::SyntaxError)

      expected = <<-SASS
      SASS
      expect(asset_style.render).to eq(expected)

      expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
      JS
      expect(asset_script.render).to eq(expected)
    end
  end

  describe '#render_partial' do
    it '...' do
      expect(chained.render_partial).to eq("<p>Processed with ERB, then Markdown.</p>\n")
      expect(page.render_partial).to eq("<p>in page</p>\n")
      expect(second_page.render_partial).to eq("<p>in page</p>\n\n<p>in page</p>\n")

      expected_style2 = <<-CSS
body{color:green}
      CSS
      expect(style_2.render_partial).to eq(expected_style2)

      expect(static_txt.render_partial).to eq('this file intentionally left blank')
      expect(post.render_partial).to eq("<p>in post</p>\n")

      expect { asset_style.render_partial }.to_not raise_error(Sass::SyntaxError)
      expected = <<-SASS
      SASS

      expect(asset_style.render_partial).to eq(expected)
      expected = <<-JS
(function ($) {
  $(document).ready(function () {
  });
})(jQuery);
      JS
      expect(asset_script.render_partial).to eq(expected)
    end
  end

  describe '#save' do
    it '...' do
      static_bin.save
      expect(static_bin.output_path.binread).to eq(static_bin.template_path.binread)

      static_txt.save
      expect(static_txt.output_path.read).to eq(static_txt.template_path.read)
    end
  end

  describe '#template_engine_options' do
    it '...' do
      expect(asset_script.template_engine_options(:sass)[:line_comments]).to be_false
      expect(asset_script.template_engine_options(:sass)[:style]).to eq(:compressed)
      expect(asset_script.template_engine_options(:js)).to eq({})
    end
  end

  describe '#template_types' do
    it '...' do
      expect(chained.template_types).to eq([:erb, :markdown])
      expect(chain.template_types).to eq([:erb, :markdown])
      expect(page.template_types).to eq([:markdown])
      expect(asset_style.template_types).to eq([:sass])
      expect(asset_script.template_types).to eq([])
    end
  end

  describe '#title' do
    it '...' do
      expect(page_nested.title).to eq('Foo -> Bar -> Baz')
    end
  end

  describe '#to_s' do
    it '...' do
      expect(category.to_s).to eq('#<Staticpress::Content::Category url_path=/category/programming, params={:name=>"programming", :number=>1}>')
      expect(Staticpress::Content::Category.new(:name => 'programming', :number => nil).to_s).to eq('#<Staticpress::Content::Category url_path=/category/programming, params={:name=>"programming", :number=>1}>')

      expect(index.to_s).to eq('#<Staticpress::Content::Index url_path=/, params={:number=>1}>')
      expect(index_2.to_s).to eq('#<Staticpress::Content::Index url_path=/page/2, params={:number=>2}>')

      expect(page_root.to_s).to eq('#<Staticpress::Content::Page url_path=/, params={:slug=>""}>')
      expect(page.to_s).to eq('#<Staticpress::Content::Page url_path=/about, params={:slug=>"about"}>')
      expect(static_bin.to_s).to eq('#<Staticpress::Content::Page url_path=/ruby.png, params={:slug=>"ruby.png"}>')

      expect(post.to_s).to eq('#<Staticpress::Content::Post url_path=/2011/07/20/hello, params={:day=>"20", :month=>"07", :title=>"hello", :year=>"2011"}>')

      expect(tag.to_s).to eq('#<Staticpress::Content::Tag url_path=/tag/charlotte, params={:name=>"charlotte", :number=>1}>')

      expect(asset_style.to_s).to eq('#<Staticpress::Content::Theme url_path=/assets/test_theme/styles/all, params={:asset_type=>"styles", :slug=>"all", :theme=>"test_theme"}>')
    end
  end

  describe '#url_path' do
    it '...' do
      expect(category.url_path).to eq('/category/programming')
      expect(category_1.url_path).to eq('/category/programming')
      expect(category_2.url_path).to eq('/category/programming/page/2')

      expect(index.url_path).to eq('/')
      expect(index_2.url_path).to eq('/page/2')

      expect(page_root.url_path).to eq('/')
      expect(chained.url_path).to eq('/chained')
      expect(chain.url_path).to eq('/chain.html')
      expect(page.url_path).to eq('/about')
      expect(second_page.url_path).to eq('/contact')
      expect(static_bin.url_path).to eq('/ruby.png')
      expect(static_txt.url_path).to eq('/plain.txt')

      expect(post.url_path).to eq('/2011/07/20/hello')

      expect(post.url_path).to eq('/2011/07/20/hello')
      expect(tag.url_path).to eq('/tag/charlotte')
      expect(asset_style.url_path).to eq('/assets/test_theme/styles/all')
    end
  end
end
