require 'ostruct'

require 'octopress'

module Octopress
  class JSObject < OpenStruct
    def [](key)
      method_missing key.to_s.to_sym
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
        value.map { |vv| converter.call vv, from_class, block }
      elsif value.is_a? from_class
        block.call value
      else
        value
      end
    end
  end
end
