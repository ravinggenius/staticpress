require 'octopress'
require 'octopress/content/physical_content'
require 'octopress/route'

module Octopress::Content
  class Post < PhysicalContent
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
      destination = Octopress.blog_path + config.posts_source + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.find_by_path(path)
      # FIXME parse path according to route pattern in config
      #filename_parts = template_path.basename.to_s.match /(?<created_on>\d{4}-\d{2}-\d{2})\./
      params = {
      #  :url_path => ,
        :content_type => self,
      #  :year => ,
      #  :month => ,
      #  :day => ,
      #  :title => 
      }
      new Octopress::Route.new(params), path.extname.sub('.', '').to_sym
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
