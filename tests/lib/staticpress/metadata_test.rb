require_relative 'js_object_test'

require 'staticpress/metadata'

class MetadataTest < JSObjectTest
  def setup
    super
    @meta = Staticpress::Metadata.new
  end

  def test__chevron
  end
end
