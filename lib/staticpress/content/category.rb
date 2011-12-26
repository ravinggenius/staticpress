require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/collection_content'
require 'staticpress/content/resource_content'

module Staticpress::Content
  class Category < Base
    extend CollectionContent
    extend ResourceContent

    attr_reader :name

    def initialize(params)
      @name = params[:name]
      super
    end

    def optional_param_defaults
      { :number => pages_count }
    end

    def pages_count
      (self.class.content_by_category[name].count / config.posts_per_page.to_f).ceil
    end

    def sub_content
      paginate(self.class.content_by_category[params[:name]].sort)[params[:number] - 1]
    end

    def template_path
      self.class.template_path
    end

    def self.all
      categories.map do |category|
        new :name => category, :number => '1'
      end
    end

    def self.categories
      content_by_category.keys
    end

    def self.content_by_category
      reply = Hash.new { |hash, key| hash[key] = [] }
      Staticpress::Content::Post.all.each do |post|
        (post.meta.categories || []).each do |category|
          (reply[category] ||= []) << post
        end
      end
      reply
    end
  end
end
