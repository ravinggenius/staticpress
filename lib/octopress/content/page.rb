require 'octopress'
require 'octopress/content/base'

module Octopress::Content
  class Page < Base
    def self.all
      all_but_posts = if (posts_dir = Octopress.blog_path + config.posts_source).directory?
        (Octopress.blog_path + config.source).children - [ posts_dir ]
      else
        (Octopress.blog_path + config.source).children
      end

      all_but_posts.map do |child|
        if child.directory?
          spider_directory child do |page|
            new page
          end
        else
          new child
        end
      end.flatten
    end

    def self.create(format, title, path = nil)
      name = title.gsub(/ /, '-').downcase

      filename = "#{name}.#{format}"
      destination = Octopress.blog_path + config.source + (path ? path : '').sub(/^\//, '') + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.find_by_route(route)
      catch :path do
        supported_extensions.each do |extension|
          path = Octopress.blog_path + config.source + "#{route[:slug]}.#{extension}"
          throw :path, new(path) if path.file?
        end
        nil
      end
    end

    def self.template
      <<-TEMPLATE
---
layout: default
---

in page
      TEMPLATE
    end
  end
end
