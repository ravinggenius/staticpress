require 'staticpress'
require 'staticpress/content/collection_content'
require 'staticpress/route'

module Staticpress::Content
  class Tag < CollectionContent
    def sub_content
      paginate(self.class.content_by_tag[route.params[:name]].sort)[(Integer route.params[:number]) - 1]
    end

    def self.all
      tags.map do |tag|
        find_by_route Staticpress::Route.new(:content_type => self, :name => tag, :number => '1')
      end
    end

    def self.tags
      content_by_tag.keys
    end

    def self.content_by_tag
      reply = {}
      Staticpress::Content::Post.all.each do |post|
        (post.meta.tags || []).each do |tag|
          (reply[tag] ||= []) << post
        end
      end
      reply
    end
  end
end
