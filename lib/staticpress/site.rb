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

module Staticpress
  class Site
    # ordered by priority
    CONTENT_TYPES = [
      Staticpress::Content::Page,
      Staticpress::Content::Post,
      Staticpress::Content::Index,
      Staticpress::Content::Category,
      Staticpress::Content::Tag,
      Staticpress::Content::Theme
    ]

    include Staticpress::Helpers

    attr_reader :directory

    def initialize
      @directory = Staticpress.blog_path + config.source_path
    end

    def all_content
      CONTENT_TYPES.map(&:all).flatten
    end

    def find_content_by_env(env)
      catch :content do
        CONTENT_TYPES.detect do |content_type|
          content = content_type.find_by_url_path env['REQUEST_PATH']
          throw :content, content if content && content.exist?
        end

        nil
      end
    end

    def meta
      # or something...
      all_content.inject(Staticpress::Metadata.new) do |m, page|
        m << page.meta
      end
    end

    def save
      destination = Staticpress.blog_path + config.destination_path
      FileUtils.rm_r destination if destination.directory?
      all_content.each &:save
    end
  end
end
