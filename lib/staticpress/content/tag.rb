require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/collection_content'
require 'staticpress/content/resource_content'

module Staticpress::Content
  class Tag < Base
    extend CollectionContent
    extend ResourceContent

    def optional_param_defaults
      { :number => 1 }
    end

    def sub_content
      paginate(self.class.content_by_tag[params[:name]].sort)[params[:number] - 1]
    end

    def template_path
      self.class.template_path
    end

    def self.all
      tags.map do |tag|
        new :name => tag, :number => '1'
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
