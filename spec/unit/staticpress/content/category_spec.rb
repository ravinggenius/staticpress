require 'spec_helper'

describe Staticpress::Content::Category do
  include Staticpress::Helpers

  set_temporary_blog_path

  let(:category) { Staticpress::Content::Category.new :name => 'programming' }

  describe '.categories' do
    it '...' do
      expect(Staticpress::Content::Category.categories).to eq([ 'programming', 'travel' ])
    end
  end

  describe '#pages_count' do
    it '...' do
      expect(category.pages_count).to eq(1)

      with_config :posts_per_page => 2 do
        expect(category.pages_count).to eq(2)
      end
    end
  end

  describe '#sub_content' do
    it '...' do
      expected = [
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '01', :title => 'announcing-staticpress'),
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '02', :title => 'staticpress'),
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress')
      ]
      expect(category.sub_content).to eq(expected)
    end
  end

  describe '.all' do
    it '...' do
      with_config :posts_per_page => 1 do
        expected = [
          Staticpress::Content::Category.new(:name => 'programming', :number => 1),
          Staticpress::Content::Category.new(:name => 'programming', :number => 2),
          Staticpress::Content::Category.new(:name => 'programming', :number => 3),
          Staticpress::Content::Category.new(:name => 'travel', :number => 1)
        ]
        expect(Staticpress::Content::Category.all).to eq(expected)
      end
    end
  end

  describe '.content_by_category' do
    it '...' do
      [
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '01', :title => 'announcing-staticpress'),
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '02', :title => 'staticpress'),
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'blogging-with-staticpress')
      ].each { |content| expect(Staticpress::Content::Category.content_by_category['programming']).to include(content) }
    end
  end
end
