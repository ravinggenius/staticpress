require 'spec_helper'

describe Staticpress::ViewHelpers do
  include Staticpress::Helpers

  let(:post) { Staticpress::Content::Post.new :year => '2011', :month => '07', :day => '20', :title => 'hello' }
  let(:view_helpers) { Staticpress::ViewHelpers.new post }

  describe '#partial_with_one_post' do
    it '...' do
      expected = <<-HTML
<section>
  <article>#{post.render_partial.strip}</article>
</section>
      HTML
      assert_equal expected, view_helpers.partial(:list_posts, :posts => [ post ])
    end
  end

  describe '#partial_with_no_posts' do
    it '...' do
      expected = <<-HTML
<section>
</section>
      HTML
      assert_equal expected, view_helpers.partial(:list_posts, :posts => [ ])
    end
  end

  describe '#tag' do
    it '...' do
      assert_equal '<t></t>', view_helpers.tag(:t)
      assert_equal '<t one="1"></t>', view_helpers.tag(:t, :one => 1)
      assert_equal '<t>content</t>', view_helpers.tag(:t) { 'content' }
      assert_equal '<t><n></n></t>', view_helpers.tag(:t) { view_helpers.tag(:n) }
    end
  end
end
