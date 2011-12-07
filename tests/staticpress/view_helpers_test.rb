require_relative '../test_case'

require 'staticpress/helpers'
require 'staticpress/view_helpers'

class ViewHelpersTest < TestCase
  include Staticpress::Helpers

  def setup
    super

    @post = Staticpress::Content::Post.new :year => '2011', :month => '07', :day => '20', :title => 'hello'

    @view_helpers = Staticpress::ViewHelpers.new @post
  end

  def test_partial_with_one_post
    expected = <<-HTML
<section>
  <article>#{@post.render_partial.strip}</article>
</section>
    HTML
    assert_equal expected, @view_helpers.partial(:list_posts, :posts => [ @post ])
  end

  def test_partial_with_no_posts
    expected = <<-HTML
<section>
</section>
    HTML
    assert_equal expected, @view_helpers.partial(:list_posts, :posts => [ ])
  end
end
