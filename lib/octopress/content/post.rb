require 'octopress'
require 'octopress/content/base'
require 'octopress/content/physical_content'

module Octopress::Content
  class Post < Base
    include Octopress::Content::PhysicalContent

    def created_on
      filename_parts = template_path.basename.to_s.match /(?<created_on>\d{4}-\d{2}-\d{2})\./
      Date.parse filename_parts[:created_on]
    end

    def template_path
      params = route.params
      stub = [
        params[:year],
        params[:month],
        params[:day],
        params[:title]
      ].join '-'

      Octopress.blog_path + config.posts_source + "#{stub}.#{template_type}"
    end

    def self.all
      if (posts_dir = Octopress.blog_path + config.posts_source).directory?
        posts_dir.children.map { |post| new post }
      else
        []
      end
    end

    def self.create(format, title)
      now = Time.now.utc
      created_on = "#{now.year}-#{'%02d' % now.month}-#{'%02d' % now.day}"
      name = title.gsub(/ /, '-').downcase

      filename = "#{created_on}-#{name}.#{format}"
      destination = Octopress.blog_path + config.posts_source + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.find_by_route(route)
      params = route.params
      stub = [
        params[:year],
        params[:month],
        params[:day],
        params[:title]
      ].join '-'

      catch :post do
        supported_extensions.detect do |extension|
          path = Octopress.blog_path + config.posts_source + "#{stub}.#{extension}"
          throw :post, new(route, extension) if path.file?
        end

        nil
      end
    end

    def self.template
      now = Time.now.utc

      <<-TEMPLATE
---
created_at: #{now}
layout: default
---

in post
      TEMPLATE
    end
  end
end
