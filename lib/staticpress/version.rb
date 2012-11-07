module Staticpress
  class Version
    extend Comparable

    SIGNATURE = [0, 6, 2]

    def self.<=>(other)
      other = other.split('.').map(&:to_i) if other.respond_to? :split
      SIGNATURE <=> Array(other)
    end

    def self.to_s
      SIGNATURE.join('.')
    end
  end
end
