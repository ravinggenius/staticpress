require_relative '../test_case'

require 'staticpress/js_object'

class JSObjectTest < TestCase
  JSO = Staticpress::JSObject

  let(:js_object) { JSO.new :key => :value, :nested => { :a => :b } }

  def test__minus
    assert_equal(JSO.new({ :key => :value, :nested => { :a => :b } }), js_object - {})
    assert_equal(JSO.new({ :nested => { :a => :b } }), js_object - { :key => :value })
    assert_equal(JSO.new({ :key => :value }), js_object - { :nested => { :a => :b } })
    assert_equal(JSO.new({}), js_object - { :key => :value, :nested => { :a => :b } })

    assert_equal(JSO.new({ :key => :value, :nested => { :a => :b } }), js_object - JSO.new({}))
    assert_equal(JSO.new({ :nested => { :a => :b } }), js_object - JSO.new({ :key => :value }))
    assert_equal(JSO.new({ :key => :value }), js_object - JSO.new({ :nested => { :a => :b } }))
    assert_equal(JSO.new({}), js_object - JSO.new({ :key => :value, :nested => { :a => :b } }))
  end

  def test__squares
    assert_nil js_object[:some_random]
    assert_equal :value, js_object[:key]
    assert_equal :value,  js_object['key']
  end

  def test_regular_access
    assert_equal :value, js_object.key
    assert_equal :b, js_object.nested.a
    assert_nil js_object.nested.other
  end

  def test_assignment
    assert_nil js_object.hoopla
    js_object.hoopla = :hullabaloo
    assert_equal :hullabaloo, js_object.hoopla
  end

  def test_merge
    assert_nil js_object.some_key
    enhanced = js_object.merge :some_key => 42
    assert_equal 42, enhanced.some_key
  end

  def test_to_hash
    assert_equal({ :key => :value, :nested => { :a => :b } }, js_object.to_hash)
  end
end
