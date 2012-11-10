require 'spec_helper'

describe Staticpress::Content::Tag do
  let(:tag) { Staticpress::Content::Tag.new :name => 'charlotte' }

  describe '.tags' do
    it '...' do
      assert_equal [ 'charlotte' ], Staticpress::Content::Tag.tags
    end
  end

  describe '#pages_count' do
    it '...' do
      assert_equal 1, tag.pages_count
    end
  end

  describe '#optional_param_defaults' do
    it '...' do
      expected = { :number => 1 }
      assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte').optional_param_defaults
      assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => nil).optional_param_defaults
    end
  end

  describe '#sub_content' do
    it '...' do
      expected = [
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
      ]
      assert_equal expected, tag.sub_content
    end
  end

  describe '.all' do
    it '...' do
      expected = [
        Staticpress::Content::Tag.new(:name => 'charlotte', :number => 1)
      ]
      assert_equal expected, Staticpress::Content::Tag.all
    end
  end

  describe '.content_by_tag' do
    it '...' do
      [
        Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
      ].each { |content| assert_includes Staticpress::Content::Tag.content_by_tag['charlotte'], content }
    end
  end
end
