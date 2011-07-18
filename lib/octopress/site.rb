require 'octopress'
require 'octopress/helpers'
require 'octopress/metadata'
require 'octopress/content/page'
require 'octopress/content/post'
require 'octopress/theme'

module Octopress
  class Site
    include Octopress::Helpers

    attr_reader :directory, :theme

    def initialize
      @directory = Octopress.blog_path + config.source
      @theme = Octopress::Theme.new config.theme
    end

    # TODO handle special pages (home, pagination, taxonomy etc)
    def all_content
      Octopress::Content::Page.all + Octopress::Content::Post.all
    end

    def find_page_by_route(route)
      hashify_pages_by(:route)[route]
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

    protected

    def hashify_pages_by(key)
      hash_from_array(all_content) { |page| page.send key }
    end
  end
end
