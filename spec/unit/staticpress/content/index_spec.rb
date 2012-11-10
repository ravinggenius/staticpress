require 'spec_helper'

describe Staticpress::Content::Index do
  include Staticpress::Helpers

  set_temporary_blog_path

  let(:index) { Staticpress::Content::Index.new }
  let(:unpublished) { Staticpress::Content::Post.new(:year => '2012', :month => '09', :day => '19', :title => 'unpublished') }

  describe '#pages_count' do
    it '...' do
      expect(index.pages_count).to eq(1)

      with_config :posts_per_page => 2 do
        expect(index.pages_count).to eq(4)
      end
    end
  end

  describe '#sub_content' do
    it '...' do
      with_config :posts_per_page => 4 do
        # expect three most recent posts with oldest on top (index is lazy-evaluated)
        expected = [
          Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'conferences'),
          Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress'),
          Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '20', :title => 'forever')
        ]
        expect(index.sub_content).to eq(expected)
        refute_includes index.sub_content, unpublished
      end
    end
  end

  describe '.all' do
    it '...' do
      with_config :posts_per_page => 3 do
        expected = [
          Staticpress::Content::Index.new(:number => 1),
          Staticpress::Content::Index.new(:number => 2),
          Staticpress::Content::Index.new(:number => 3)
        ]
        expect(Staticpress::Content::Index.all).to eq(expected)
      end
    end
  end
end
