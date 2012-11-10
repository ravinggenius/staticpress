require 'spec_helper'

describe Staticpress::Content::Tag do
  let(:tag) { Staticpress::Content::Tag.new :name => 'charlotte' }

  describe '.tags' do
    assert_equal [ 'charlotte' ], Staticpress::Content::Tag.tags
  end

  describe '#pages_count' do
    assert_equal 1, tag.pages_count
  end

  describe '#optional_param_defaults' do
    expected = { :number => 1 }
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte').optional_param_defaults
    assert_equal expected, Staticpress::Content::Tag.new(:name => 'charlotte', :number => nil).optional_param_defaults
  end

  describe '#sub_content' do
    expected = [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
    ]
    assert_equal expected, tag.sub_content
  end

  describe '.all' do
    expected = [
      Staticpress::Content::Tag.new(:name => 'charlotte', :number => 1)
    ]
    assert_equal expected, Staticpress::Content::Tag.all
  end

  describe '.content_by_tag' do
    [
      Staticpress::Content::Post.new(:year => '2011', :month => '08', :day => '06', :title => 'in-charlotte')
    ].each { |content| assert_includes Staticpress::Content::Tag.content_by_tag['charlotte'], content }
  end
end
