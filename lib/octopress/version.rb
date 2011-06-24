module Octopress
  class Version
    MAJOR = 0
    MINOR = 0
    PATCH = 0

    def self.to_s
      [ MAJOR, MINOR, PATCH ].join '.'
    end
  end
end
