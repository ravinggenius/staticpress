module Octopress
  class ContentType
    def self.inherited(type_class)
      @types ||= {}
      @types[type_class.key] = type_class.pattern
    end

    def self.key
      name.to_sym
    end

    def self.types
      @types
    end
  end
end
