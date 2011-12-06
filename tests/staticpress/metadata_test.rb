require_relative 'js_object_test'

require 'staticpress/metadata'

class MetadataTest < JSObjectTest
  def setup
    super
    @meta = Staticpress::Metadata.new
    @another_meta = Staticpress::Metadata.new :layout => 'post_index', :categories => %w[programming], :tags => %w[code tutorial]
  end

  def test__chevron
  end

  def test_inspect
    assert_equal '#<Staticpress::Metadata>', @meta.inspect
    assert_equal '#<Staticpress::Metadata categories=["programming"], layout="post_index", tags=["code", "tutorial"]>', @another_meta.inspect
  end
end
