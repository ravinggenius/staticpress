require 'octopress/content_type'

module Octopress::ContentTypes
  class Page < Octopress::ContentType
    def self.pattern
      '%{name}'
    end
  end
end
