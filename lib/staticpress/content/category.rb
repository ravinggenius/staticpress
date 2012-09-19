module Staticpress::Content
  class Category < Base
    include CollectionContent
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
      reply = []

      content_by_category.each do |category, posts|
        1.upto paginate(posts).count do |number|
          reply << new(:name => category, :number => number)
        end
      end

      reply
    end

    def self.published
      all
    end

    def self.categories
      content_by_category.keys
    end

    def self.content_by_category
      reply = Hash.new { |hash, key| hash[key] = [] }
      Staticpress::Content::Post.published.each do |post|
        (post.meta.categories || []).each do |category|
          (reply[category] ||= []) << post
        end
      end
      reply
    end
  end
end
