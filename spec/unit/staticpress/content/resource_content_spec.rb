require 'spec_helper'

describe Staticpress::Content::ResourceContent do
  include Staticpress::Helpers
  include Staticpress::Content::ResourceContent

  set_temporary_blog_path

  let(:page_dir) { Staticpress.blog_path + config.source_path }

  describe '.find_supported_extensions' do
    it '...' do
      expect(find_supported_extensions(page_dir + 'chained.markdown.erb')).to eq([:erb, :markdown])
      expect(find_supported_extensions(page_dir + 'chained.markdown')).to eq([:erb, :markdown])
      expect(find_supported_extensions(page_dir + 'chained')).to eq([:erb, :markdown])
      expect(find_supported_extensions(page_dir + 'about')).to eq([:markdown])
      expect(find_supported_extensions(page_dir + 'plain.txt')).to eq([])
      expect(find_supported_extensions(page_dir + 'i/dont/exist')).to eq([])
    end
  end
end
