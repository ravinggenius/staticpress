require 'ostruct'

require 'octopress'

module Octopress
  class JSObject < OpenStruct
    def [](key)
      method_missing key.to_s.to_sym
    end

    def to_hash
      handler = lambda do |v|
        if v.is_a? Array
          v.map { |vv| handler.call vv }
        elsif v.is_a? JSObject
          v.to_hash
        else
          v
        end
      end

      converted = {}

      @table.each do |key, value|
        converted[key] = handler.call value
      end

      converted
    end

    def self.new(hash = {})
      handler = lambda do |v|
        if v.is_a? Array
          v.map { |vv| handler.call vv }
        elsif v.is_a? Hash
          new v
        else
          v
        end
      end

      converted = {}

      hash.each do |key, value|
        converted[key] = handler.call value
      end

      super converted
    end
  end
end
