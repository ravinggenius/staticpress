require 'staticpress'
require 'staticpress/content/physical_content'
require 'staticpress/route'

module Staticpress::Content
  class Page < PhysicalContent
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
      end.flatten
    end

    def self.create(format, title, path = nil)
      name = title.gsub(/ /, '-').downcase

      filename = "#{name}.#{format}"
      destination = Staticpress.blog_path + config.source + (path ? path : '').sub(/^\//, '') + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.find_by_path(path)
      slug = extensionless_path(path).to_s.sub((Staticpress.blog_path + config.source).to_s, '').sub(/^\//, '')
      params = {
        :content_type => self,
        :slug => slug
      }
      find_by_route Staticpress::Route.new(params) if path.file?
    end

    def self.find_by_route(route)
      return nil unless route

      catch :page do
        supported_extensions.each do |extension|
          path = Staticpress.blog_path + config.source + "#{route.params[:slug]}.#{extension}"
          throw :page, new(route, path) if path.file?
        end

        nil
      end
    end

    def self.template
      <<-TEMPLATE
in page
      TEMPLATE
    end
  end
end
