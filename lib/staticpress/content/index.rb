module Staticpress::Content
  class Index < Base
    include CollectionContent
    extend CollectionContent

    def optional_param_defaults
      { :number => pages_count }
    end

    def pages_count
      (self.class.all_posts.count / config.posts_per_page.to_f).ceil
    end

    def sub_content
      paginate(self.class.all_posts.sort)[params[:number] - 1]
    end

    def template_path
      self.class.template_path
    end

    def self.all
      (1..paginate(all_posts).count).map do |number|
        new(:number => number)
      end
    end

    def self.all_posts
      Staticpress::Content::Post.all
    end
  end
end
