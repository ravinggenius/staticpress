require 'pathname'

require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/resource_content'
require 'staticpress/content/static_content'
require 'staticpress/route'

module Staticpress::Content
  class Page < Base
    include StaticContent
    include ResourceContent
    extend ResourceContent
    extend StaticContent

    attr_reader :extension, :full_slug

    def initialize(params)
      super

      index = extensionless_basename Pathname.new(config.index_file)

      @full_slug = params[:slug]
      @extension = find_supported_extension(Staticpress.blog_path + config.source_path + full_slug)

      if @extension.nil? && !template_path.file?
        @full_slug = [
          params[:slug],
          index
        ].reject(&:empty?).join('/')
        @extension = find_supported_extension(Staticpress.blog_path + config.source_path + full_slug)
      end
    end

    def save
      save!
    end

    def static?
      (Staticpress.blog_path + config.source_path + params[:slug]).file?
    end

    def template_path
      slug = extension ? "#{full_slug}.#{extension}" : full_slug
      Staticpress.blog_path + config.source_path + slug
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
        raw_slug = parse_slug(path, (Staticpress.blog_path + config.source_path)).first
        basename = extensionless_basename Pathname.new(config.index_file)
        slug = raw_slug.sub(/.*(\/?#{basename})$/, '')
        new :slug => slug
      end
    end

    def self.template
      <<-TEMPLATE
in page
      TEMPLATE
    end
  end
end
