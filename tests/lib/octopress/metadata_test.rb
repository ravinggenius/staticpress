require_relative 'js_object_test'

require 'octopress'
require 'octopress/metadata'

class MetadataTest < JSObjectTest
  def setup
    super
    @meta = Octopress::Metadata.new
  end

  def test__chevron
  end
end
