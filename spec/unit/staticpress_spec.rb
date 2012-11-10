require 'spec_helper'

describe Staticpress do
  describe '.blog_path' do
    assert_equal Pathname('tests/test_blog').expand_path, Staticpress.blog_path
  end

  describe '.blog_path=' do
    Staticpress.blog_path = 'some/other/directory'
    assert_equal Pathname('some/other/directory').expand_path, Staticpress.blog_path
  end

  describe '.root' do
    assert_equal Pathname('lib/').expand_path, Staticpress.root
  end
end
