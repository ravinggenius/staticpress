require 'octopress/content_type'

module Octopress::ContentTypes
  class Post < Octopress::ContentType
    def self.key
      :post
    end

    def self.pattern
      '%{date}-%{name}'
    end
  end
end
