require 'staticpress'
require 'staticpress/content/ethereal_content'
require 'staticpress/route'

module Staticpress::Content
  class Category < EtherealContent
    def content
      { :text => template_path.read }
    end

    def sub_content
      Staticpress::Content::Post.all.map do |post|
        post if post.meta.categories && post.meta.categories.include?(route.params[:name])
      end.compact
    end

    def self.all
      categories.map { |category| find_by_category category }
    end

    def self.categories
      Staticpress::Content::Post.all.map do |post|
        post.meta.categories
      end.compact.flatten.uniq
    end

    def self.find_by_category(category)
      new Staticpress::Route.new(:content_type => self, :name => category), template_path.extname.sub('.', '').to_sym
    end
  end
end
