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
      expect(view_helpers.partial(:list_posts, :posts => [ post ])).to eq(expected)
    end
  end

  describe '#partial_with_no_posts' do
    it '...' do
      expected = <<-HTML
<section>
</section>
      HTML
      expect(view_helpers.partial(:list_posts, :posts => [ ])).to eq(expected)
    end
  end

  describe '#tag' do
    it '...' do
      expect(view_helpers.tag(:t)).to eq('<t></t>')
      expect(view_helpers.tag(:t, :one => 1)).to eq('<t one="1"></t>')
      expect(view_helpers.tag(:t) { 'content' }).to eq('<t>content</t>')
      expect(view_helpers.tag(:t) { view_helpers.tag(:n) }).to eq('<t><n></n></t>')
    end
  end
end
