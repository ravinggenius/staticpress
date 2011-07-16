require_relative '../../test_helper'

require 'octopress/js_object'

class JSObjectTest < MiniTest::Unit::TestCase
  def setup
    @js_object = Octopress::JSObject.new :key => :value, :nested => { :a => :b }
  end

  def test_
    assert_nil @js_object[:some_random]
    assert_equal @js_object[:key], :value
    assert_equal @js_object['key'], :value
    assert_equal @js_object.key, :value
    assert_equal @js_object.nested.a, :b
    assert_nil @js_object.nested.other
  end

  def test_to_hash
    assert_equal @js_object.to_hash, { :key => :value, :nested => { :a => :b } }
  end
end
