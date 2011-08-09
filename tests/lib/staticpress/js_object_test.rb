require_relative '../../test_helper'

require 'staticpress/js_object'

class JSObjectTest < TestHelper
  def setup
    @js_object = Staticpress::JSObject.new :key => :value, :nested => { :a => :b }
  end

  def test__squares
    assert_nil @js_object[:some_random]
    assert_equal :value, @js_object[:key]
    assert_equal :value,  @js_object['key']
  end

  def test_regular_access
    assert_equal :value, @js_object.key
    assert_equal :b, @js_object.nested.a
    assert_nil @js_object.nested.other
  end

  def test_assignment
    assert_nil @js_object.hoopla
    @js_object.hoopla = :hullabaloo
    assert_equal :hullabaloo, @js_object.hoopla
  end

  def test_to_hash
    assert_equal({ :key => :value, :nested => { :a => :b } }, @js_object.to_hash)
  end
end
