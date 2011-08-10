require 'staticpress'
require 'staticpress/content/ethereal_content'
require 'staticpress/route'

module Staticpress::Content
  class Category < EtherealContent
    def content
      { :text => template_path.read }
    end

    def self.all
      Staticpress::Content::Post.all.map do |post|
        post if post.meta.categories
      end.compact
    end
  end
end
