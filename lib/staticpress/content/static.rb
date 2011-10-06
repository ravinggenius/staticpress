require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/error'
require 'staticpress/route'

module Staticpress::Content
  class Static < Base
    def render_partial(locals = {})
      raise Staticpress::Error, 'Static content types should not use #render_partial'
    end

    def self.all
      all_but_posts = if (posts_dir = Staticpress.blog_path + config.posts_source).directory?
        (Staticpress.blog_path + config.source).children - [ posts_dir ]
      else
        (Staticpress.blog_path + config.source).children
      end

      all_but_posts.map do |child|
        if child.directory?
          spider_directory child do |page|
            find_by_path page
          end
        else
          find_by_path child
        end
      end.flatten.compact
    end

    def self.find_by_path(path)
      slug = path.to_s.sub((Staticpress.blog_path + config.source).to_s, '').sub(/^\//, '')
      params = {
        :content_type => self,
        :slug => slug
      }
      if path.file? && supported_extensions.none? { |ext| path.to_s.end_with? ext.to_s }
        find_by_route Staticpress::Route.new(params)
      end
    end

    def self.find_by_route(route)
      return nil unless route

      path = Staticpress.blog_path + config.source + "#{route.params[:slug]}"

      path.file? ? new(route, path) : nil
    end
  end
end
