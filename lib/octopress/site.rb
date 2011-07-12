require 'octopress'
require 'octopress/helpers'
require 'octopress/metadata'
require 'octopress/page'
require 'octopress/theme'

module Octopress
  class Site
    include Octopress::Helpers

    attr_reader :theme

    def initialize
      @theme = Octopress::Theme.new config.theme
    end

    def find_page_by_path(path)
      hashify_pages_by(:path)[path]
    end

    def find_page_by_route(route)
      hashify_pages_by(:route)[route]
    end

    # TODO handle special pages (home, pagination, taxonomy etc)
    def list_all_pages_for(dir = Octopress.blog_path + config.source)
      dir.children.map do |child|
        if child.directory?
          list_all_pages_for child
        else
          Octopress::Page.new child, theme
        end
      end.flatten
    end

    def list_all_pages
      list_all_pages_for
    end

    def meta
      # or something...
      list_all_pages.inject(Octopress::Metadata.new) do |m, page|
        m << page.meta
      end
    end

    def save
      list_all_pages.each &:save
    end

    protected

    def hashify_pages_by(key)
      Hash[list_all_pages.map { |page| [ page.send(key), page ] }]
    end
  end
end
