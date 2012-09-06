module Staticpress
  class Settings < JSObject
    def self.default
      new 'verbose' => false
    end

    def self.instance
      new(default.to_hash.merge(@runtime_settings || {}))
    end

    def self.set!(settings)
      (@runtime_settings ||= {}).merge!(settings)
    end
  end
end
