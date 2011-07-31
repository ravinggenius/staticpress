require 'fileutils'
require 'tilt'
require 'yaml'

require 'octopress'
require 'octopress/metadata'
require 'octopress/theme'

module Octopress::Content
  class Base
    extend Octopress::Helpers
    include Octopress::Helpers

    attr_reader :route, :template_type, :theme

    def initialize(route, template_type)
      @route = route
      @template_type = template_type
      @theme = Octopress::Theme.new config.theme
    end

    def ==(other)
      other.respond_to?(:content) && (content == other.content)
    end

    def inspect
      parts = [ "url_path=#{route.url_path}" ]

      "#<#{self.class} #{parts.join ', '}>"
    end

    def layout
      Tilt.new theme.layout_for(meta.layout).to_s
    end

    def meta
      Octopress::Metadata.new(content.names.include?('frontmatter') ? YAML.load(content[:frontmatter]) : {})
    end

    def raw
      content[:text].strip
    end

    def render
      template = Tilt[template_type].new { raw }

      if l = layout
        l.render Object.new, template_locals do
          template.render Object.new, template_locals
        end
      else
        template.render Object.new, template_locals
      end
    end

    def save
      destination = route.file_path
      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write render }
    end

    def template_locals
      {
        :config => config,
        :meta => meta,
        :page => self
      }
    end

    def title
      if meta.title
        meta.title
      else
        route.url_path.split(/\/-/).map do |word|
          word.capitalize
        end.join ' '
      end
    end

    def type
      self.class.name.split('::').last.downcase
    end

    def self.content_types
      @content_types || []
    end

    def self.inherited(klass)
      (@content_types ||= [])  << klass
    end

    def self.supported_extensions
      Tilt.mappings.keys.map &:to_sym
    end

    def self.spider_directory(dir, &block)
      dir.children.map do |child|
        if child.directory?
          spider_directory child, &block
        else
          block.call child
        end
      end
    end
  end
end
