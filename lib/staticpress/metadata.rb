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
    alias :to_s :inspect
  end
end
