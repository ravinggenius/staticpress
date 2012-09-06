require 'ostruct'

module Staticpress
  class JSObject < OpenStruct
    def -(other)
      other_hash = other.to_hash
      difference = to_hash.select do |key, value|
        value != other_hash[key]
      end
      self.class.new difference
    end

    def [](key)
      method_missing key.to_s.to_sym
    end

    def merge(other)
      self.class.new to_hash.merge(other.to_hash)
    end

    def to_hash
      converted = {}

      @table.each do |key, value|
        converted[key] = self.class.converter(value, JSObject) { |v| v.to_hash }
      end

      converted
    end

    def self.new(hash = {})
      converted = {}

      hash.each do |key, value|
        converted[key] = converter(value, Hash) { |v| new v }
      end

      super converted
    end

    protected

    def self.converter(value, from_class, &block)
      if value.is_a? Array
        value.map { |vv| converter vv, from_class, &block }
      elsif value.is_a? from_class
        block.call value
      else
        value
      end
    end
  end
end
