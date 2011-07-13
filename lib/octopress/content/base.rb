require 'fileutils'
require 'tilt'
require 'yaml'

require 'octopress'

module Octopress::Content
  class Base
    include Octopress::Helpers

    attr_reader :path, :route_title

    def initialize(path, theme)
      parts = (@path = path).basename.to_s.match /(?<route_title>.*)\./

      @route_title = parts[:route_title]
      @theme = theme
    end

    def content
      return @content if @content

      regex_frontmatter = /^-{3}${1}(?<frontmatter>.*)^-{3}${1}/m
      regex_text = /(?<text>.*)/m
      regex = /#{regex_frontmatter}#{regex_text}/

      @content = (c = path.read).match(regex_frontmatter) ? c.match(regex) : c.match(regex_text)
    end

    def layout
      Tilt.new @theme.layout_for(meta['layout']).to_s
    end

    def meta
      content.names.include?('frontmatter') ? YAML.load(content[:frontmatter]) : {}
    end

    def render
      template = Tilt[path.to_s].new { content[:text] }

      if l = layout
        l.render template_locals do
          template.render template_locals
        end
      else
        template.render template_locals
      end
    end

    def route
      config.routes[type] % route_options(route_title)
    end

    def save
      destination = Octopress.blog_path + config.destination + route.sub('/', '')
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
          word.upcase
        end.join ' '
      end
    end

    def type
      self.class.name.split('::').last.downcase
    end
  end
end
