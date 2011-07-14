require 'octopress'
require 'octopress/content/base'

module Octopress::Content
  class Page < Base
    def self.all
      all_but_posts = (Octopress.blog_path + 'content').children - ([Octopress.blog_path + 'content' + '_posts'])

      all_but_posts.map do |child|
        if child.directory?
          spider_directory child do |page|
            new page, theme
          end
        else
          new child, theme
        end
      end.flatten
    end

    def self.create(format, title, path = nil)
      name = title.gsub(/ /, '-').downcase

      filename = "#{name}.#{format}"
      destination = Octopress.blog_path + 'content' + (path ? path : '').sub(/^\//, '') + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
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
