require 'spec_helper'

describe Staticpress::JSObject do
  JSO = Staticpress::JSObject

  let(:js_object) { JSO.new :key => :value, :nested => { :a => :b } }

  describe '#-' do
    it '...' do
      assert_equal(JSO.new({ :key => :value, :nested => { :a => :b } }), js_object - {})
      assert_equal(JSO.new({ :nested => { :a => :b } }), js_object - { :key => :value })
      assert_equal(JSO.new({ :key => :value }), js_object - { :nested => { :a => :b } })
      assert_equal(JSO.new({}), js_object - { :key => :value, :nested => { :a => :b } })

      assert_equal(JSO.new({ :key => :value, :nested => { :a => :b } }), js_object - JSO.new({}))
      assert_equal(JSO.new({ :nested => { :a => :b } }), js_object - JSO.new({ :key => :value }))
      assert_equal(JSO.new({ :key => :value }), js_object - JSO.new({ :nested => { :a => :b } }))
      assert_equal(JSO.new({}), js_object - JSO.new({ :key => :value, :nested => { :a => :b } }))
    end
  end

  describe '#[]' do
    it '...' do
      assert_nil js_object[:some_random]
      assert_equal :value, js_object[:key]
      assert_equal :value,  js_object['key']
    end
  end

  describe 'regular access' do
    it '...' do
      assert_equal :value, js_object.key
      assert_equal :b, js_object.nested.a
      assert_nil js_object.nested.other
    end
  end

  describe 'assignment' do
    it '...' do
      assert_nil js_object.hoopla
      js_object.hoopla = :hullabaloo
      assert_equal :hullabaloo, js_object.hoopla
    end
  end

  describe '#merge' do
    it '...' do
      assert_nil js_object.some_key
      enhanced = js_object.merge :some_key => 42
      assert_equal 42, enhanced.some_key
    end
  end

  describe '#to_hash' do
    it '...' do
      assert_equal({ :key => :value, :nested => { :a => :b } }, js_object.to_hash)
    end
  end
end
