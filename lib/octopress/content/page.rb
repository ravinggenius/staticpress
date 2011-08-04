require 'octopress'
require 'octopress/content/base'
require 'octopress/content/physical_content'
require 'octopress/route'

module Octopress::Content
  class Page < Base
    include Octopress::Content::PhysicalContent

    def template_path
      Octopress.blog_path + config.source + "#{route.params[:slug]}.#{template_type}"
    end

    def self.all
      all_but_posts = if (posts_dir = Octopress.blog_path + config.posts_source).directory?
        (Octopress.blog_path + config.source).children - [ posts_dir ]
      else
        (Octopress.blog_path + config.source).children
      end

      all_but_posts.map do |child|
        if child.directory?
          spider_directory child do |page|
            find_by_path page
          end
        else
          find_by_path child
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

    def self.find_by_path(path)
      # FIXME this feels like cheating
      url_path = path.to_s.sub((Octopress.blog_path + config.source).to_s, '').sub("#{path.extname}", '')
      params = {
        :url_path => url_path,
        :content_type => self,
        :slug => url_path.sub(/^\//, '')
      }
      new Octopress::Route.new(params), path.extname.sub(/^\./, '').to_sym
    end

    def self.find_by_route(route)
      catch :page do
        supported_extensions.each do |extension|
          path = Octopress.blog_path + config.source + "#{route.params[:slug]}.#{extension}"
          throw :page, new(route, extension) if path.file?
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
