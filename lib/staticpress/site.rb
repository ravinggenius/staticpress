require 'fileutils'

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

    include Enumerable
    include Staticpress::Helpers

    attr_reader :directory

    def initialize
      @directory = Staticpress.blog_path + config.source_path
    end

    def each(&block)
      threads = []
      semaphore = Mutex.new

      CONTENT_TYPES.each do |content_type|
        threads << Thread.new do
          content_type.published.each do |content|
            semaphore.synchronize do
              block.call content
            end
          end
        end
      end

      threads.each &:join
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
      inject(Staticpress::Metadata.new) { |meta, content| meta << content.meta }
    end

    def save
      destination = Staticpress.blog_path + config.destination_path
      FileUtils.rm_r destination if destination.directory?
      each &:save
    end
  end
end
