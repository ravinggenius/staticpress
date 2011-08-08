require 'octopress'
require 'octopress/content/ethereal_content'
require 'octopress/route'

module Octopress::Content
  class Category < EtherealContent
    def content
      { :text => '' }
    end

    def self.all
      Octopress::Content::Post.all.map do |post|
        post if post.meta.categories
      end.compact
    end
  end
end
