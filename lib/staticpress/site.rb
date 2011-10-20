require 'fileutils'

require 'staticpress'
require 'staticpress/content/index'
require 'staticpress/content/category'
require 'staticpress/content/tag'
require 'staticpress/content/page'
require 'staticpress/content/post'
require 'staticpress/content/theme'
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
      destination = Staticpress.blog_path + config.destination
      FileUtils.rm_r destination if destination.directory?
      all_content.each &:save
    end

    def self.content_types
      [
        Staticpress::Content::Index,
        Staticpress::Content::Category,
        Staticpress::Content::Tag,
        Staticpress::Content::Page,
        Staticpress::Content::Post,
        Staticpress::Content::Theme
      ]
    end
  end
end
