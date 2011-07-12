require 'fileutils'
require 'tilt'
require 'yaml'

require 'octopress'

module Octopress
  class Page
    include Octopress::Helpers

    attr_reader :created_on, :path, :type

    # filename should be a string like type-created_on-title.extension(s)
    def initialize(path, theme)
      filename = (@path = path).basename.to_s
      parts = filename.split '-'
      @created_on = Date.parse parts[1]
      @type = parts[0].to_sym
      @unprocessed_title = filename.sub "#{parts[0]}-#{parts[1]}-", ''
      @theme = theme
    end

    def layout
      Tilt.new @theme.layout_for(meta[:layout])
    end

    # https://github.com/mojombo/jekyll/blob/v0.10.0/lib/jekyll/convertible.rb#L23
    def meta
      content = path.read

      if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        YAML.load(content[($1.size + $2.size)..-1])
      else
        {}
      end
    end

    def render
      # NOTE may need to read file manually to remove yaml frontmatter
      # NOTE grab layout from Octopress::Theme#layout
      template = Tilt.new path.to_s

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
      FileUtils.mkdir_p destination
      destination.open('w') { |f| f.write render }
    end

    # route begins with /
    def route
      @route = nil # calculate route based on type
      pattern = config.routes[type]
    end

    def template_locals
      {
        :config => config,
        :meta => meta,
        :page => self
      }
    end

    def title
      meta.title || @unprocessed_title.split('-').map do |word|
        word.upcase
      end.join ' '
    end
  end
end
