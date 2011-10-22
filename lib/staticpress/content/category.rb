require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/collection_content'
require 'staticpress/route'

module Staticpress::Content
  class Category < Base
    extend CollectionContent

    def sub_content
      paginate(self.class.content_by_category[route.params[:name]].sort)[(Integer route.params[:number]) - 1]
    end

    def self.all
      categories.map do |category|
        find_by_route Staticpress::Route.new(:content_type => self, :name => category, :number => '1')
      end
    end

    def self.categories
      content_by_category.keys
    end

    def self.content_by_category
      reply = {}
      Staticpress::Content::Post.all.each do |post|
        (post.meta.categories || []).each do |category|
          (reply[category] ||= []) << post
        end
      end
      reply
    end
  end
end
