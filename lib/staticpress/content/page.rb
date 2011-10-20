require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/route'

module Staticpress::Content
  class Page < Base
    def static?
      self.class.static? route.params[:slug]
    end

    def layout
      static? ? nil : super
    end

    def render_partial(locals = {})
      static? ? template_path_content : super
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

    def self.create(format, title, path = nil)
      name = title.gsub(/ /, '-').downcase

      filename = "#{name}.#{format}"
      destination = Staticpress.blog_path + config.source + (path ? path : '').sub(/^\//, '') + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.find_by_path(path)
      if path.file?
        path_string = path.to_s

        slug = if supported_extensions.any? { |ext| path_string.end_with? ext.to_s }
          extensionless_path(path).to_s.sub((Staticpress.blog_path + config.source).to_s, '').sub(/^\//, '')
        else
          path_string.sub((Staticpress.blog_path + config.source).to_s, '').sub(/^\//, '')
        end

        params = {
          :content_type => self,
          :slug => slug
        }

        find_by_route Staticpress::Route.new(params)
      end
    end

    def self.find_by_route(route)
      return nil unless route

      catch :page do
        supported_extensions.each do |extension|
          path = Staticpress.blog_path + config.source + "#{route.params[:slug]}.#{extension}"
          throw :page, new(route, path) if path.file?
        end

        static?(route.params[:slug]) ? new(route, (Staticpress.blog_path + config.source + route.params[:slug])) : nil
      end
    end

    def self.static?(slug)
      (Staticpress.blog_path + config.source + slug).file?
    end

    def self.template
      <<-TEMPLATE
in page
      TEMPLATE
    end
  end
end
