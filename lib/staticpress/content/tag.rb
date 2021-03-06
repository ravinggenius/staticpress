module Staticpress::Content
  class Tag < Base
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
      (self.class.content_by_tag[name].count / config.posts_per_page.to_f).ceil
    end

    def sub_content
      paginate(self.class.content_by_tag[params[:name]].sort)[params[:number] - 1]
    end

    def preferred_layout_names
      reply = []

      if params[:name].nil?
        reply << :tag
      else
        if params[:number].nil?
          reply << :tag_index
          reply << :post_index
        end

        reply << :tag_paged
        reply << :post_paged
      end

      reply
    end

    def self.all
      reply = []

      content_by_tag.each do |tag, posts|
        1.upto paginate(posts).count do |number|
          reply << new(:name => tag, :number => number)
        end
      end

      reply
    end

    def self.published
      all
    end

    def self.tags
      content_by_tag.keys
    end

    def self.content_by_tag
      reply = Hash.new { |hash, key| hash[key] = [] }
      Staticpress::Content::Post.published.each do |post|
        (post.meta.tags || []).each do |tag|
          (reply[tag] ||= []) << post
        end
      end
      reply
    end
  end
end
