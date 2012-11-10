require 'spec_helper'

describe Staticpress do
  set_temporary_blog_path 'test_blog'

  describe '.blog_path' do
    it 'correctly guesses where the blog is' do
      expect(Staticpress.blog_path).to eq(Pathname('tmp/test_blog').expand_path)
    end
  end

  describe '.blog_path=' do
    before do
      Staticpress.blog_path = 'some/other/directory'
    end

    it 'can set the blog path explicitly' do
      expect(Staticpress.blog_path).to eq(Pathname('some/other/directory').expand_path)
    end
  end

  describe '.root' do
    it 'knows where it is installed to' do
      expect(Staticpress.root).to eq(Pathname('lib').expand_path)
    end
  end
end
