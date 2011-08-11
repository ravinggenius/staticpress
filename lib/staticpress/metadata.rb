require 'staticpress'
require 'staticpress/js_object'

module Staticpress
  class Metadata < JSObject
    def <<(other)
      self
    end

    def inspect
      details = to_hash.sort.map do |key, value|
        "#{key}=#{value.inspect}"
      end.join(', ')

      parts = [
        self.class,
        (details unless details.empty?)
      ].compact

      "#<#{parts.join(' ')}>"
    end
  end
end
