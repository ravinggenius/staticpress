require 'spec_helper'

# TODO add contexts
describe Staticpress::Route do
  describe '.extract_params_index' do
    it '...' do
      pattern = '/(page/:number)?'

      expect(Staticpress::Route.extract_params(pattern, '/')).to eq(:number => nil)
      expect(Staticpress::Route.extract_params(pattern, '/page/2')).to eq(:number => '2')

      expect(Staticpress::Route.extract_params(pattern, '/plain.txt')).to be_nil
    end
  end

  describe '.extract_params_page' do
    it '...' do
      pattern = '/:slug'

      expect(Staticpress::Route.extract_params(pattern, '/')).to eq(:slug => '')
      expect(Staticpress::Route.extract_params(pattern, '/hello')).to eq(:slug => 'hello')
    end
  end

  describe '.extract_params_post' do
    it '...' do
      pattern = '/:year/:month/:day/:title'

      expect(Staticpress::Route.extract_params(pattern, '/2011/11/11/hello-world')).to eq(:year => '2011', :month => '11', :day => '11', :title => 'hello-world')
    end
  end

  describe '.extract_params_theme' do
    it '...' do
      pattern = '/assets/:theme/:asset_type/:slug'

      expect(Staticpress::Route.extract_params(pattern, '/assets/default/styles/screen.css')).to eq(:theme => 'default', :asset_type => 'styles', :slug => 'screen.css')
    end
  end

  describe '.regex_for_pattern_index' do
    it '...' do
      pattern = '/(page/:number)?'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/page/1')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/page/2')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/page/17')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/contact/page/27')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/static_text/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_page_1' do
    it '...' do
      pattern = '/:slug'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/page/1')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/static_text/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/static_text/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/blog/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_page_2' do
    it '...' do
      pattern = '/static_text/:slug'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/static_text/page/123')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/static_text/page/xyz')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/static_text/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/static_text/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/static_text/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/static_text/files/profile.jpg')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/blog/2011/07/20/hello-world')
    end
  end

  describe '.regex_for_pattern_post_1' do
    it '...' do
      pattern = '/:year/:month/:day/:title'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/2011/07/20/hello-world')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/static_text/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/blog/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_post_2' do
    it '...' do
      pattern = '/blog/:year/:month/:day/:title'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/blog/2011/07/20/hello-world')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/blog/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_post_3' do
    it '...' do
      pattern = '/:year/:title'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/2011/hello-world')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/blog/2011/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_post_4' do
    it '...' do
      pattern = '/blog/:year/:title'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/blog/2011/hello-world')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/2011/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/blog/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_tag_1' do
    it '...' do
      pattern = '/tag/:name(/page/:number)?'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/tag/programming')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/tag/programming/page/0')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/static_text/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/something/tag/programming')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_tag_2' do
    it '...' do
      pattern = '/something/tag/:name(/page/:number)?'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/something/tag/programming')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/something/tag/programming/page/123456')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/static_text/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/tag/programming')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_category_1' do
    it '...' do
      pattern = '/category/:name(/page/:number)?'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/category/programming')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/category/programming/page/5')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/static_text/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/blog/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end

  describe '.regex_for_pattern_category_2' do
    it '...' do
      pattern = '/blog/category/:name(/page/:number)?'

      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/blog/category/programming')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to match('/blog/category/programming/page/20')

      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/about/us')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/static_text/about')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/blog/2011/07/20/hello-world')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/category/programming')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/plain.txt')
      expect(Staticpress::Route.regex_for_pattern(pattern)).to_not match('/files/profile.jpg')
    end
  end
end
