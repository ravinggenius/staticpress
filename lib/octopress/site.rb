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

    def all_content
      all_content_types.map(&:all).flatten
    end

    # TODO handle special pages (home, pagination, taxonomy etc)
    def all_content_types
      [
        Octopress::Content::Page,
        Octopress::Content::Post
      ]
    end

    def find_page_by_route(route)
      catch :content do
        all_content_types.each do |content_type|
          route_hash = route_regex_stubs.inject({}) do |reply, regex|
            match = route.match regex
            if match
              match.names.each { |match_key| reply[match_key.to_sym] = match[match_key] }
            end
            reply
          end

          content = content_type.find_by_route(route_hash)
          throw :content, content if content
        end
        nil
      end
    end

    def meta
      # or something...
      all_content.inject(Octopress::Metadata.new) do |m, page|
        m << page.meta
      end
    end

    def route_regex_stubs
      [
        /(?<date>\d{4}-\d{2}-\d{2})/,
        /(?<year>\d{4})/,
        /\d{4}\/(?<month>\d{2})/,
        /(?<day>\d{2})/,
        /^\/(?<slug>[0-9a-z\-_\/]*)$/,
        /(?<title>[0-9a-z\-_]*)$/
      ]
    end

    def save
      all_content.each &:save
    end
  end
end
