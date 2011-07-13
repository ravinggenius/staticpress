require 'fileutils'
require 'tilt'
require 'yaml'

require 'octopress'

module Octopress
  class Page
    include Octopress::Helpers

    attr_reader :created_on, :path, :route_title, :type

    def initialize(path, theme)
      parts = (@path = path).basename.to_s.match /(?<type>\w*){1}-(?<created_on>\d{4}-\d{2}-\d{2})-(?<route_title>.*)\./

      @created_on = Date.parse parts[:created_on]
      @type = parts[:type]
      @route_title = parts[:route_title]
      @theme = theme
    end

    def content
      @content ||= path.read.match /^-{3}${1}(?<frontmatter>.*)^-{3}${1}(?<text>.*)/m
    end

    def layout
      Tilt.new @theme.layout_for(meta['layout']).to_s
    end

    def meta
      if content[:frontmatter]
        YAML.load(content[:frontmatter])
      else
        {}
      end
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

    def save
      destination = Octopress.blog_path + config.destination + route.sub('/', '')
      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write render }
    end

    def route
      config.routes[type] % route_options(route_title)
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
  end
end
