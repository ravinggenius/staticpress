require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/resource_content'
require 'staticpress/content/static_content'
require 'staticpress/route'

module Staticpress::Content
  class Page < Base
    include StaticContent
    extend ResourceContent
    extend StaticContent

    def static?
      (Staticpress.blog_path + config.source_path + route.params[:slug]).file?
    end

    def self.all
      all_but_posts = if (posts_dir = Staticpress.blog_path + config.posts_source_path).directory?
        (Staticpress.blog_path + config.source_path).children - [ posts_dir ]
      else
        (Staticpress.blog_path + config.source_path).children
      end

      gather_resources_from all_but_posts
    end

    def self.create(format, title, path = nil)
      name = title.gsub(/ /, '-').downcase

      filename = "#{name}.#{format}"
      destination = Staticpress.blog_path + config.source_path + (path ? path : '').sub(/^\//, '') + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.find_by_path(path)
      if path.file?
        params = {
          :content_type => self,
          :slug => parse_slug(path, (Staticpress.blog_path + config.source_path))
        }

        find_by_route Staticpress::Route.new(params)
      end
    end

    def self.find_by_route(route)
      return nil unless route

      base = Staticpress.blog_path + config.source_path
      path = base + route.params[:slug]
      return new(route, path) if path.file?

      load_resource route, base, route.params[:slug]
    end

    def self.template
      <<-TEMPLATE
in page
      TEMPLATE
    end
  end
end
