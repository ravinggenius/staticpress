require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/resource_content'
require 'staticpress/route'

module Staticpress::Content
  class Post < Base
    include ResourceContent
    extend ResourceContent

    def initialize(params)
      super
      # FIXME calculate template_path
      @template_types = find_supported_extensions template_path
    end

    def <=>(other)
      other.respond_to?(:created_at) ? (created_at <=> other.created_at) : super
    end

    def created_at
      meta.created_at ? meta.created_at : created_on
    end

    def created_on
      Time.utc params[:year], params[:month], params[:day]
    end

    def template_path
      name = [
        params[:year],
        params[:month],
        params[:day],
        "#{params[:title]}#{template_extension}"
      ].join('-')
      Staticpress.blog_path + config.posts_source_path + name
    end

    def title
      if meta.title
        meta.title
      else
        titleize(params[:title])
      end
    end

    def self.all
      if (posts_dir = Staticpress.blog_path + config.posts_source_path).directory?
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
      destination = Staticpress.blog_path + config.posts_source_path + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.find_by_path(path)
      if path.file?
        stubs = Staticpress::Route::REGEX_STUBS
        regex = /#{stubs[:year].regex}-#{stubs[:month].regex}-#{stubs[:day].regex}-#{stubs[:title].regex}\.(.+)/

        if filename_parts = path.basename.to_s.match(regex)
          new hash_from_match_data(filename_parts)
        end
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
