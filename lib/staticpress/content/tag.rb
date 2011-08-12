require 'staticpress'
require 'staticpress/content/ethereal_content'
require 'staticpress/route'

module Staticpress::Content
  class Tag < EtherealContent
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
      new Staticpress::Route.new(:content_type => self, :name => tag), template_path.extname
    end
  end
end
