require 'staticpress'
require 'staticpress/content/physical_content'
require 'staticpress/route'

module Staticpress::Content
  class Post < PhysicalContent
    def created_on
      # TODO pull parts out of route.params
      filename_parts = template_path.basename.to_s.match /(?<created_on>\d{4}-\d{2}-\d{2})\./
      Date.parse filename_parts[:created_on]
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
      filename_parts = path.basename.to_s.match /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})-(?<title>[0-9a-z\-_]*)\./
      params = {
        :content_type => self,
        :year => filename_parts[:year],
        :month => filename_parts[:month],
        :day => filename_parts[:day],
        :title => filename_parts[:title]
      }
      find_by_route Staticpress::Route.new(params) if path.file?
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
          path = Staticpress.blog_path + config.posts_source + "#{stub}.#{extension}"
          throw :post, new(route, path) if path.file?
        end

        nil
      end
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
