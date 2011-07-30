require 'octopress'
require 'octopress/content/base'
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
      Octopress::Content::Base.content_types.map(&:all).flatten
    end

    def find_page_by_route(route)
      Octopress::Route.new(route).content
    end

    def meta
      # or something...
      all_content.inject(Octopress::Metadata.new) do |m, page|
        m << page.meta
      end
    end

    def save
      all_content.each &:save
    end
  end
end
