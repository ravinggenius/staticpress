require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/resource_content'
require 'staticpress/route'

module Staticpress::Content
  class Post < Base
    extend ResourceContent

    def <=>(other)
      other.respond_to?(:created_at) ? (created_at <=> other.created_at) : super
    end

    def created_at
      meta.created_at ? meta.created_at : created_on
    end

    def created_on
      date = route.params
      Time.utc date[:year], date[:month], date[:day]
    end

    def self.all
      if (posts_dir = Staticpress.blog_path + config.posts_source).directory?
        posts_dir.children.map { |post| find_by_path post }
      else
        []
      end
    end

    def self.create(format, title)
      now = Time.now.utc
      created_on = "#{now.year}-#{'%02d' % now.month}-#{'%02d' % now.day}"
      name = title.gsub(/ /, '-').downcase

      filename = "#{created_on}-#{name}.#{format}"
      destination = Staticpress.blog_path + config.posts_source + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.find_by_path(path)
      if path.file?
        stubs = Staticpress::Route::REGEX_STUBS
        regex = /#{stubs[:year].regex}-#{stubs[:month].regex}-#{stubs[:day].regex}-#{stubs[:title].regex}/

        if filename_parts = path.basename.to_s.match(regex)
          params = {
            :content_type => self,
            :year => filename_parts[:year],
            :month => filename_parts[:month],
            :day => filename_parts[:day],
            :title => filename_parts[:title]
          }
          find_by_route Staticpress::Route.new(params)
        end
      end
    end

    def self.find_by_route(route)
      return nil unless route

      base = Staticpress.blog_path + config.posts_source
      parts = route.params
      stub = [
        parts[:year],
        parts[:month],
        parts[:day],
        parts[:title]
      ].join '-'

      load_resource route, base, stub
    end

    def self.template
      now = Time.now.utc

      <<-TEMPLATE
---
created_at: #{now}
---

in post
      TEMPLATE
    end
  end
end
