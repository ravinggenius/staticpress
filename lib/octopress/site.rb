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
      all_pages + all_posts
    end

    def all_pages
      all_but_posts = (Octopress.blog_path + 'content').children - ([Octopress.blog_path + 'content' + '_posts'])

      all_but_posts.map do |child|
        if child.directory?
          spider_directory child do |page|
            Octopress::Content::Page.new page, theme
          end
        else
          Octopress::Content::Page.new child, theme
        end
      end.flatten
    end

    def all_posts
      spider_directory directory + '_posts' do |post|
        Octopress::Content::Post.new post, theme
      end.flatten
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

    def spider_directory(dir, &block)
      dir.children.map do |child|
        if child.directory?
          spider_directory child, &block
        else
          block.call child
        end
      end
    end

    protected

    def hashify_pages_by(key)
      Hash[all_content.map { |page| [ page.send(key), page ] }]
    end
  end
end
