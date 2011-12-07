require_relative '../test_case'

require 'staticpress/route'

class RouteTest < TestCase
  def test_extract_params_index
    pattern = '/(page/:number)?'

    assert_equal({ :number => nil }, Staticpress::Route.extract_params(pattern, '/'))
    assert_equal({ :number => '2' }, Staticpress::Route.extract_params(pattern, '/page/2'))

    assert_nil nil, Staticpress::Route.extract_params(pattern, '/plain.txt')
  end

  def test_extract_params_page
    pattern = '/:slug'

    assert_equal({ :slug => '' }, Staticpress::Route.extract_params(pattern, '/'))
    assert_equal({ :slug => 'hello' }, Staticpress::Route.extract_params(pattern, '/hello'))
  end

  def test_extract_params_post
    pattern = '/:year/:month/:day/:title'

    assert_equal({ :year => '2011', :month => '11', :day => '11', :title => 'hello-world' }, Staticpress::Route.extract_params(pattern, '/2011/11/11/hello-world'))
  end

  def test_extract_params_theme
    pattern = '/assets/:theme/:asset_type/:slug'

    assert_equal({ :theme => 'default', :asset_type => 'styles', :slug => 'screen.css' }, Staticpress::Route.extract_params(pattern, '/assets/default/styles/screen.css'))
  end

  def test_regex_for_pattern_index
    pattern = '/(page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/page/1'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/page/2'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/page/17'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/contact/page/27'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_page_1
    pattern = '/:slug'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/page/1'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_page_2
    pattern = '/static_text/:slug'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/page/123'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/page/xyz'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/plain.txt'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/files/profile.jpg'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
  end

  def test_regex_for_pattern_post_1
    pattern = '/:year/:month/:day/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_post_2
    pattern = '/blog/:year/:month/:day/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_post_3
    pattern = '/:year/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/2011/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_post_4
    pattern = '/blog/:year/:title'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/hello-world'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_tag_1
    pattern = '/tag/:name(/page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/tag/programming'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/tag/programming/page/0'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/something/tag/programming'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_tag_2
    pattern = '/something/tag/:name(/page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/something/tag/programming'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/something/tag/programming/page/123456'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/tag/programming'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_category_1
    pattern = '/category/:name(/page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/category/programming'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/category/programming/page/5'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end

  def test_regex_for_pattern_category_2
    pattern = '/blog/category/:name(/page/:number)?'

    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/category/programming'
    assert_match Staticpress::Route.regex_for_pattern(pattern), '/blog/category/programming/page/20'

    refute_match Staticpress::Route.regex_for_pattern(pattern), '/about/us'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/static_text/about'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/blog/2011/07/20/hello-world'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/category/programming'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/plain.txt'
    refute_match Staticpress::Route.regex_for_pattern(pattern), '/files/profile.jpg'
  end
end
