require 'octopress/content_type'

module Octopress::ContentTypes
  class Post < Octopress::ContentType
    def self.pattern
      '%{date}-%{name}'
    end
  end
end
