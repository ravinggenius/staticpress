require 'pathname'

module Staticpress::Content
  class Page < Base
    include StaticContent
    include ResourceContent
    extend ResourceContent
    extend StaticContent

    attr_reader :full_slug

    def initialize(params = {})
      super

      source_path = Staticpress.blog_path + config.source_path

      @full_slug = params[:slug]
      @template_types = find_supported_extensions(source_path + full_slug)

      unless template_path.file?
        @full_slug = [
          params[:slug],
          extensionless_basename(Pathname(config.index_file))
        ].reject(&:empty?).join('/')
        @template_types = find_supported_extensions(source_path + full_slug)
      end
    end

    def save
      save!
    end

    def static?
      (Staticpress.blog_path + config.source_path + params[:slug]).file?
    end

    def template_path
      Staticpress.blog_path + config.source_path + "#{full_slug}#{template_extension}"
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

    def self.extract_slug(path)
      base_path = Staticpress.blog_path + config.source_path
      supported = find_supported_extensions(path)
      extension = supported.empty? ? '' : "\\.#{supported.reverse.join('\.')}"

      if match = /^#{base_path}\/(?<slug>.+)#{extension}$/.match(path.to_s)
        basename = extensionless_basename Pathname(config.index_file)
        match[:slug].sub(/.*(\/?#{basename})$/, '')
      end
    end

    def self.find_by_path(path)
      new :slug => extract_slug(path) if path.file?
    end

    def self.template
      <<-TEMPLATE
in page
      TEMPLATE
    end
  end
end
