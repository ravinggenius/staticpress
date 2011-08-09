require 'fileutils'

require 'staticpress'
require 'staticpress/content/index'
require 'staticpress/content/pagination'
require 'staticpress/content/category'
require 'staticpress/content/tag'
require 'staticpress/content/page'
require 'staticpress/content/post'
require 'staticpress/helpers'
require 'staticpress/metadata'
require 'staticpress/route'

module Staticpress
  class Site
    include Staticpress::Helpers

    attr_reader :directory

    def initialize
      @directory = Staticpress.blog_path + config.source
    end

    def all_content
      self.class.content_types.map(&:all).flatten
    end

    def find_content_by_url_path(url_path)
      route = Staticpress::Route.from_url_path url_path
      route.content if route
    end

    def meta
      # or something...
      all_content.inject(Staticpress::Metadata.new) do |m, page|
        m << page.meta
      end
    end

    def save
      FileUtils.rm_r(Staticpress.blog_path + config.destination)
      all_content.each &:save
    end

    def self.content_types
      [
        Staticpress::Content::Index,
        Staticpress::Content::Pagination,
        Staticpress::Content::Category,
        Staticpress::Content::Tag,
        Staticpress::Content::Page,
        Staticpress::Content::Post
      ]
    end
  end
end
