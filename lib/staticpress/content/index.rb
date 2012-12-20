module Staticpress::Content
  class Index < Base
    include CollectionContent
    include ResourceContent

    def optional_param_defaults
      { :number => pages_count }
    end

    def pages_count
      (self.class.all_posts.count / config.posts_per_page.to_f).ceil
    end

    def sub_content
      paginate(self.class.all_posts.sort)[params[:number] - 1]
    end

    def preferred_layout_names
      reply = []
      reply << :post_index if params[:number].nil?
      reply << :post_paged
      reply
    end

    def self.all
      (1..paginate(all_posts).count).map do |number|
        new(:number => number)
      end
    end

    def self.published
      all
    end

    def self.all_posts
      Staticpress::Content::Post.published
    end
  end
end
