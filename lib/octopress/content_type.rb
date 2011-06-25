module Octopress
  class ContentType
    def self.inherited(type_class)
      @types ||= []
      @types << type_class
    end

    def self.types
      Hash[@types.map(&:key).zip(@types.map(&:pattern))]
    end
  end
end
