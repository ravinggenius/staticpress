module Staticpress
  # TODO figure out how to implement Gem::Version properly
  class Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0

    def self.to_s
      [ MAJOR, MINOR, PATCH ].join '.'
    end
  end
end
