require 'spec_helper'

describe Staticpress::JSObject do
  JSO = Staticpress::JSObject

  basic_blog

  let(:js_object) { JSO.new :key => :value, :nested => { :a => :b } }

  describe '#-' do
    it '...' do
      expect(js_object - {}).to eq(JSO.new(:key => :value, :nested => { :a => :b }))
      expect(js_object - { :key => :value }).to eq(JSO.new(:nested => { :a => :b }))
      expect(js_object - { :nested => { :a => :b } }).to eq(JSO.new(:key => :value))
      expect(js_object - { :key => :value, :nested => { :a => :b } }).to eq(JSO.new({}))

      expect(JSO.new(:key => :value, :nested => { :a => :b })).to eq(js_object - JSO.new({}))
      expect(JSO.new(:nested => { :a => :b })).to eq(js_object - JSO.new(:key => :value))
      expect(JSO.new(:key => :value)).to eq(js_object - JSO.new(:nested => { :a => :b }))
      expect(JSO.new({})).to eq(js_object - JSO.new(:key => :value, :nested => { :a => :b }))
    end
  end

  describe '#[]' do
    it '...' do
      expect(js_object[:some_random]).to be_nil
      expect(js_object[:key]).to eq(:value)
      expect(js_object['key']).to eq(:value)
    end
  end

  describe 'regular access' do
    it '...' do
      expect(js_object.key).to eq(:value)
      expect(js_object.nested.a).to eq(:b)
      expect(js_object.nested.other).to be_nil
    end
  end

  describe 'assignment' do
    it '...' do
      expect(js_object.hoopla).to be_nil
      js_object.hoopla = :hullabaloo
      expect(js_object.hoopla).to eq(:hullabaloo)
    end
  end

  describe '#merge' do
    it '...' do
      expect(js_object.some_key).to be_nil
      enhanced = js_object.merge :some_key => 42
      expect(enhanced.some_key).to eq(42)
    end
  end

  describe '#to_hash' do
    it '...' do
      expect(js_object.to_hash).to eq(:key => :value, :nested => { :a => :b })
    end
  end
end
