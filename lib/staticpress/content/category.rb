module Staticpress::Content
  class Category < Base
    include CollectionContent
    include ResourceContent

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

    def preferred_layout_names
      reply = []

      if params[:name].nil?
        reply << :category
      else
        if params[:number].nil?
          reply << :category_index
          reply << :post_index
        end

        reply << :category_paged
        reply << :post_paged
      end

      reply
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
