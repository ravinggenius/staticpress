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

    attr_reader :route, :template_path

    def initialize(route, template_path)
      @route = route
      @template_path = template_path
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
      if meta.layout || config.markup_templates.include?(template_path.extname[1..-1])
        layout_name = meta.layout || :default
        Tilt.new theme.layout_for(layout_name).to_s
      end
    end

    def meta
      Staticpress::Metadata.new(content.names.include?('frontmatter') ? YAML.load(content[:frontmatter]) : {})
    end

    def output_path
      base = Staticpress.blog_path + config.destination_path + route.url_path.sub(/^\//, '')
      (config.index_file && config.markup_templates.include?(template_path.extname[1..-1])) ? base + config.index_file : base
    end

    def raw
      content[:text].strip
    end

    def render(locals = {})
      if l = layout
        l.render template_context, locals do
          render_partial locals
        end
      else
        render_partial locals
      end
    end

    def render_partial(locals = {})
      template = Tilt[template_path].new { raw }
      template.render template_context, locals
    end

    def save
      FileUtils.mkdir_p output_path.dirname
      output_path.open('w') { |f| f.write render }
    end

    def template_context
      Staticpress::ViewHelpers.new self
    end

    def template_path_content
      exist? ? template_path.read : ''
    end

    def template_type
      template_path.extname.sub(/^\./, '').to_sym
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
