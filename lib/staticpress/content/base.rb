require 'fileutils'
require 'tilt'
require 'yaml'

require 'staticpress'
require 'staticpress/metadata'
require 'staticpress/theme'
require 'staticpress/view_helpers'

module Staticpress::Content
  class Base
    extend Staticpress::Helpers
    include Staticpress::Helpers

    attr_reader :route, :template_type

    def initialize(route, template_type)
      @route = route
      @template_type = template_type.to_s.sub(/^\./, '').to_sym
    end

    def ==(other)
      other.respond_to?(:route) && (route == other.route)
    end

    def content
      return @content if @content

      regex_frontmatter = /^-{3}${1}(?<frontmatter>.*)^-{3}${1}/m
      regex_text = /(?<text>.*)/m
      regex = /#{regex_frontmatter}#{regex_text}/

      c = template_path_content
      @content = c.match(regex_frontmatter) ? c.match(regex) : c.match(regex_text)
    end

    def exist?
      template_path.file?
    end

    def inspect
      parts = [ "url_path=#{route.url_path}" ]

      "#<#{self.class} #{parts.join ', '}>"
    end
    alias to_s inspect

    def layout
      Tilt.new theme.layout_for(meta.layout).to_s
    end

    def meta
      Staticpress::Metadata.new(content.names.include?('frontmatter') ? YAML.load(content[:frontmatter]) : {})
    end

    def raw
      content[:text].strip
    end

    def render
      if l = layout
        l.render Object.new, template_locals do
          render_partial
        end
      else
        render_partial
      end
    end

    def render_partial
      template = Tilt[template_type].new { raw }
      template.render Staticpress::ViewHelpers.new(theme), template_locals
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

    def template_path_content
      exist? ? template_path.read : ''
    end

    def theme
      self.class.theme
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

    def self.spider_directory(dir, &block)
      dir.children.map do |child|
        if child.directory?
          spider_directory child, &block
        else
          block.call child
        end
      end
    end

    def self.supported_extensions
      Tilt.mappings.keys.map &:to_sym
    end

    def self.theme
      Staticpress::Theme.theme
    end

    def self.type
      name.split('::').last.downcase
    end
  end
end
