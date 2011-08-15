require 'staticpress'
require 'staticpress/content/collection_content'
require 'staticpress/route'

module Staticpress::Content
  class Index < CollectionContent
    def sub_content
      Staticpress::Content::Post.all
    end

    def self.all
      [
        (find_by_route Staticpress::Route.new(:content_type => self))
      ]
    end
  end
end
