require 'spec_helper'

describe Staticpress::Site do
  let(:site) { Staticpress::Site.new }

  let(:index) { Staticpress::Content::Page.new :slug => '' }
  let(:page) { Staticpress::Content::Page.new :slug => 'about' }
  let(:post) { Staticpress::Content::Post.new :year => '2011', :month => '07', :day => '20', :title => 'hello' }

  describe '.find_content_by_env' do
    assert_equal index, site.find_content_by_env(env('/'))
    assert_equal page, site.find_content_by_env(env('/about'))
    assert_equal post, site.find_content_by_env(env('/2011/07/20/hello'))
    assert_nil site.find_content_by_env(env('/i/dont/exist'))
  end

  describe '#save' do
    refute_raises(ArgumentError) { site.save }
  end
end
