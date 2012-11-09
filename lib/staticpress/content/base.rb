require 'fileutils'
require 'rack/mime'
require 'tilt'
require 'yaml'

module Staticpress::Content
  class Base
    extend Staticpress::Helpers
    include Staticpress::Helpers

    attr_reader :params, :template_types

    def initialize(params = {})
      clean_params = params.select { |key, value| value }.map do |key, value|
        cast_value = case Staticpress::Route::REGEX_STUBS[key].klass
          when :integer then Integer value rescue value
          when :symbol  then value.to_sym
          else               value
        end

        [ key, cast_value ]
      end

      @params = optional_param_defaults.merge Hash[clean_params]
      @template_types = []
    end

    def ==(other)
      other.respond_to?(:params) && (params == other.params) &&
        other.respond_to?(:url_path) && (url_path == other.url_path)
    end

    def content
      return @content if @content

      regex_frontmatter = /^-{3}${1}(?<frontmatter>.*)^-{3}${1}/m
      regex_text = /(?<text>.*)/m
      regex = /(#{regex_frontmatter})?#{regex_text}/

      c = template_path_content

      @content = if Tilt.mappings.include?(template_path.extname[1..-1])
        c.match regex
      else
        { :text => c }
      end
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

    def markup_template?
      config.markup_templates.include?(template_path.extname[1..-1])
    end

    def meta
      Staticpress::Metadata.new(content[:frontmatter] ? YAML.load(content[:frontmatter]) : {})
    rescue Psych::SyntaxError => e
      warn "Could not parse frontmatter for #{template_path}", content[:frontmatter]
      raise e
    end

    def optional_param_defaults
      {}
    end

    def output_path
      base = Staticpress.blog_path + config.destination_path + url_path.sub(/^\//, '')

      # FIXME need a better check
      if (markup_template? && config.index_file && (Pathname(config.index_file).extname != base.extname))
        base + config.index_file
      else
        base
      end
    end

    def published?
      published = meta.published
      if published.is_a? Time
        published <= Time.utc
      else
        published.nil? ? true : published
      end
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
      template_types.inject(raw) do |result, template_type|
        template = Tilt.new(template_type.to_s, template_engine_options(template_type)) { result }
        template.render template_context, locals
      end
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

    def template_engine_options(template_type)
      (config.template_engine_options[template_type] || {}).to_hash
    end

    def template_extension
      template_types.empty? ? '' : ".#{template_types.reverse.join('.')}"
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
