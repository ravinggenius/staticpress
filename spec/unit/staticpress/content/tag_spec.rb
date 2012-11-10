require 'spec_helper'

describe Staticpress::Content::Tag do
  let(:tag) { Staticpress::Content::Tag.new :name => 'charlotte' }

  set_temporary_blog_path

  describe '.tags' do
    it '...' do
      expect(Staticpress::Content::Tag.tags).to eq([ 'charlotte' ])
    end
  end

  describe '#pages_count' do
    it '...' do
      expect(tag.pages_count).to eq(1)
    end
  end

  describe '#optional_param_defaults' do
    it '...' do
      expected = { :number => 1 }
      expect(Staticpress::Content::Tag.new(:name => 'charlotte').optional_param_defaults).to eq(expected)
      expect(Staticpress::Content::Tag.new(:name => 'charlotte', :number => nil).optional_param_defaults).to eq(expected)
    end
  end

  describe '#sub_content' do
    it '...' do
      expected = [
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
      ]
      expect(tag.sub_content).to eq(expected)
    end
  end

  describe '.all' do
    it '...' do
      expected = [
        Staticpress::Content::Tag.new(:name => 'charlotte', :number => 1)
      ]
      expect(Staticpress::Content::Tag.all).to eq(expected)
    end
  end

  describe '.content_by_tag' do
    it '...' do
      [
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
      ].each { |content| expect(Staticpress::Content::Tag.content_by_tag['charlotte']).to include(content) }
    end
  end
end
