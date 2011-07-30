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

    attr_reader :path, :route_title, :theme

    def initialize(path)
      parts = (@path = path).basename.to_s.match /(?<route_title>.*)\./

      @route_title = parts[:route_title]
      @theme = Octopress::Theme.new config.theme
    end

    def ==(other)
      other.respond_to?(:route) && (route == other.route)
    end

    def content
      return @content if @content

      regex_frontmatter = /^-{3}${1}(?<frontmatter>.*)^-{3}${1}/m
      regex_text = /(?<text>.*)/m
      regex = /#{regex_frontmatter}#{regex_text}/

      @content = (c = path.read).match(regex_frontmatter) ? c.match(regex) : c.match(regex_text)
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
      template = Tilt[path.to_s].new { raw }

      if l = layout
        l.render Object.new, template_locals do
          template.render Object.new, template_locals
        end
      else
        template.render Object.new, template_locals
      end
    end

    def route
      route_options(route_title).inject(route_pattern) do |reply, (key, value)|
        reply.gsub /:#{key}/, value.to_s
      end
    end

    def route_pattern
      config.routes[type]
    end

    def save
      destination = Octopress.blog_path + config.destination + route.sub(/^\//, '')
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
        route_title.split('-').map do |word|
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
