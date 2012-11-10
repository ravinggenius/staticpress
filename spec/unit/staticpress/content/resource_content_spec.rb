require 'spec_helper'

describe Staticpress::Content::ResourceContent do
  include Staticpress::Helpers
  include Staticpress::Content::ResourceContent

  let(:page_dir) { Staticpress.blog_path + config.source_path }

  def test_find_supported_extensions
    assert_equal [:erb, :markdown], find_supported_extensions(page_dir + 'chained.markdown.erb')
    assert_equal [:erb, :markdown], find_supported_extensions(page_dir + 'chained.markdown')
    assert_equal [:erb, :markdown], find_supported_extensions(page_dir + 'chained')
    assert_equal [:markdown], find_supported_extensions(page_dir + 'about')
    assert_equal [], find_supported_extensions(page_dir + 'plain.txt')
    assert_equal [], find_supported_extensions(page_dir + 'i/dont/exist')
  end
end
