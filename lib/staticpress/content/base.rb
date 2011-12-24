require 'fileutils'
require 'rack/mime'
require 'tilt'
require 'yaml'

require 'staticpress'
require 'staticpress/metadata'
require 'staticpress/route'
require 'staticpress/theme'
require 'staticpress/view_helpers'

module Staticpress::Content
  class Base
    extend Staticpress::Helpers
    include Staticpress::Helpers

    attr_reader :params

    def initialize(params)
      clean_params = params.select { |key, value| value }.map do |key, value|
        cast_value = case Staticpress::Route::REGEX_STUBS[key].klass
          when :integer then Integer value rescue value
          when :symbol  then value.to_sym
          else               value
        end

        [ key, cast_value ]
      end

      @params = optional_param_defaults.merge Hash[clean_params]
    end

    def ==(other)
      other.respond_to?(:params) && (params == other.params) &&
      other.respond_to?(:url_path) && (url_path == other.url_path)
    end

    def content
      return @content if @content

      regex_frontmatter = /^-{3}${1}(?<frontmatter>.*)^-{3}${1}/m
      regex_text = /(?<text>.*)/m
      regex = /#{regex_frontmatter}#{regex_text}/

      c = template_path_content
      @content = c.match(regex_frontmatter) ? c.match(regex) : c.match(regex_text)
    end

    def content_type
      Rack::Mime.mime_type output_path.extname
    end

    def exist?
      template_path.file?
    end

    def full_title
      [
        title,
        config.title
      ].join config.title_separators.site
    end

    def layout
      if meta.layout || config.markup_templates.include?(template_path.extname[1..-1])
        layout_name = meta.layout || :default
        Tilt.new theme.layout_for(layout_name).to_s
      end
    end

    def meta
      Staticpress::Metadata.new(content.names.include?('frontmatter') ? YAML.load(content[:frontmatter]) : {})
    end

    def optional_param_defaults
      {}
    end

    def output_path
      base = Staticpress.blog_path + config.destination_path + url_path.sub(/^\//, '')
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
      template = Tilt.new(template_path.to_s, template_engine_options) { raw }
      template.render template_context, locals
    end

    def save
      save! unless output_path.file?
    end

    def save!
      if settings.verbose
        width = config.routes.to_hash.keys.max_by { |sym| sym.to_s.length }.to_s.length
        type = self.class.type.rjust width
        path = output_path.to_s.sub Staticpress.blog_path.to_s + '/', ''
        puts "#{type} #{path}"
      end

      FileUtils.mkdir_p output_path.dirname
      output_path.open('w') { |f| f.write render }
    end

    def template_context
      Staticpress::ViewHelpers.new self
    end

    def template_engine_options
      (config.template_engine_options[template_type] || {}).to_hash
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
        titleize(url_path)
      end
    end

    def to_s
      "#<#{self.class} url_path=#{url_path}, params=#{Hash[params.sort]}>"
    end

    def url_path
      # grab url pattern for content type
      pattern = config.routes[self.class.type].clone

      # regex to find optional segment in pattern
      # NOTE cannot find more than one optional segment per pattern
      optional_segment_finder = /\((?<optional_segment>.+)\)\?/

      # replace optional segment in pattern with result of block
      # optional segments should have one keys
      pattern.gsub! optional_segment_finder do |optional_segment|
        # http://www.rubular.com/r/LiOup53CI1
        # http://www.rubular.com/r/TE7E9ZdtKF

        # grab the key from optional segment
        optional_key = /:(?<optional_key>[0-9a-z_]+)/.match(optional_segment)[:optional_key].to_sym

        # if params has the optional key and params optional key is not the key's default, remove optional segment indicators
        # otherwise return nil to remove optional segment entirely
        optional_segment_finder.match(optional_segment)[:optional_segment] if params[optional_key] && (params[optional_key] != optional_param_defaults[optional_key])
      end

      # actually do conversion from pattern to url path
      Staticpress::Route::REGEX_STUBS.keys.inject(pattern) do |p, key|
        p.gsub /:#{key}/, params[key].to_s
      end
    end

    def self.find_by_url_path(url_path)
      params = Staticpress::Route.extract_params config.routes[type], url_path
      new params if params
    end

    def self.theme
      Staticpress::Theme.theme
    end

    def self.type
      name.split('::').last.downcase
    end
  end
end
