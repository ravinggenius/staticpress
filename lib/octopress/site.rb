require 'fileutils'

require 'octopress'
require 'octopress/content/index'
require 'octopress/content/pagination'
require 'octopress/content/category'
require 'octopress/content/tag'
require 'octopress/content/page'
require 'octopress/content/post'
require 'octopress/helpers'
require 'octopress/metadata'
require 'octopress/route'
require 'octopress/theme'

module Octopress
  class Site
    include Octopress::Helpers

    attr_reader :directory, :theme

    def initialize
      @directory = Octopress.blog_path + config.source
      @theme = Octopress::Theme.new config.theme
    end

    def all_content
      self.class.content_types.map(&:all).flatten
    end

    def find_content_by_url_path(url_path)
      route = Octopress::Route.from_url_path url_path
      route.content if route
    end

    def meta
      # or something...
      all_content.inject(Octopress::Metadata.new) do |m, page|
        m << page.meta
      end
    end

    def save
      FileUtils.rm_r(Octopress.blog_path + config.destination)
      all_content.each &:save
    end

    def self.content_types
      [
        Octopress::Content::Index,
        Octopress::Content::Pagination,
        Octopress::Content::Category,
        Octopress::Content::Tag,
        Octopress::Content::Page,
        Octopress::Content::Post
      ]
    end
  end
end
