require 'octopress/content_type'

module Octopress::ContentTypes
  class Page < Octopress::ContentType
    def self.key
      :page
    end

    def self.pattern
      '%{name}'
    end
  end
end
