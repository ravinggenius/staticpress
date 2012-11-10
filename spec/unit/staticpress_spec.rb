require 'spec_helper'

describe Staticpress do
  describe '.blog_path' do
    it 'correctly guesses where the blog is' do
      assert_equal Pathname('tests/test_blog').expand_path, Staticpress.blog_path
    end
  end

  describe '.blog_path=' do
    before do
      Staticpress.blog_path = 'some/other/directory'
    end

    it 'can set the blog path explicitly' do
      assert_equal Pathname('some/other/directory').expand_path, Staticpress.blog_path
    end
  end

  describe '.root' do
    it 'knows where it is installed to' do
      assert_equal Pathname('lib/').expand_path, Staticpress.root
    end
  end
end
