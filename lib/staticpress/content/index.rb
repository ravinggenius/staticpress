require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/collection_content'
require 'staticpress/route'

module Staticpress::Content
  class Index < Base
    extend CollectionContent

    def sub_content
      paginate(Staticpress::Content::Post.all)[(Integer route.params[:number]) - 1]
    end

    def self.all
      [
        (find_by_route Staticpress::Route.new(:content_type => self, :number => '1'))
      ]
    end
  end
end
