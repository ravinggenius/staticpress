require 'staticpress'
require 'staticpress/content/collection_content'
require 'staticpress/route'

module Staticpress::Content
  class Tag < CollectionContent
    def sub_content
      Staticpress::Content::Post.all.map do |post|
        post if post.meta.tags && post.meta.tags.include?(route.params[:name])
      end.compact
    end

    def self.all
      tags.map { |tag| find_by_tag tag }
    end

    def self.tags
      Staticpress::Content::Post.all.map do |post|
        post.meta.tags
      end.compact.flatten.uniq
    end

    def self.find_by_tag(tag)
      find_by_route Staticpress::Route.new(:content_type => self, :name => tag)
    end
  end
end
