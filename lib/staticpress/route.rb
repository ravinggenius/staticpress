require 'staticpress'
require 'staticpress/error'
require 'staticpress/helpers'

module Staticpress
  class Route
    extend Staticpress::Helpers
    include Staticpress::Helpers

    RegexStub = Struct.new :regex, :default

    REGEX_STUBS = {
      :date => RegexStub.new(/(?<date>\d{4}-\d{2}-\d{2})/),
      :year => RegexStub.new(/(?<year>\d{4})/),
      :month => RegexStub.new(/(?<month>\d{2})/),
      :day => RegexStub.new(/(?<day>\d{2})/),
      :slug => RegexStub.new(/(?<slug>[0-9a-z\-_\/]+)/),
      :title => RegexStub.new(/(?<title>[0-9a-z\-_]*)/),
      :name => RegexStub.new(/(?<name>[0-9a-z\-_]*)/),
      :number => RegexStub.new(/(?<number>\d+)/, '1')
    }

    attr_reader :params

    def initialize(params)
      # TODO apply default values to all params for which a default value exist
      @params = if params.key?(:number)
        params[:number] ? params : params.merge(:number => REGEX_STUBS[:number].default)
      else
        params
      end
    end

    def ==(other)
      other.respond_to?(:params) && (params == other.params)
    end

    def content
      params[:content_type].find_by_route self
    end

    def inspect
      parts = [
        "url_path=#{url_path}",
        "content_type=#{params[:content_type]}"
      ]

      p = Hash[self.params.clone.sort]
      p.delete :content_type
      parts << "params=#{p}"

      "#<#{self.class} #{parts.join ', '}>"
    end

    def route
      route_options(route_title).inject(route_pattern) do |reply, (key, value)|
        reply.gsub /:#{key}/, value.to_s
      end
    end

    def route_options(title)
      t = Time.now.utc

      {
        :date => "#{t.year}-#{'%02d' % t.month}-#{'%02d' % t.day}",
        :year => t.year,
        :month => '%02d' % t.month,
        :day => '%02d' % t.day,
        :title => title
      }
    end

    def route_pattern
      config.routes[type]
    end

    def file_path
      return nil unless url_path
      Staticpress.blog_path + config.destination + url_path.sub(/^\//, '') + config.index_file
    end

    def url_path
      return nil unless params[:content_type]

      pattern = config.routes[params[:content_type].type].clone

      # http://www.rubular.com/r/UTV5dNDq6c
      optional_segment_finder = /\((?<optional_segment>.+)\)\?/
      pattern.gsub! optional_segment_finder do |match|
        # http://www.rubular.com/r/LiOup53CI1
        optional_key = /:(?<optional_key>[0-9a-z_]+)/.match(match)[:optional_key].to_sym
        optional_segment_finder.match(match)[:optional_segment] unless params[optional_key] == REGEX_STUBS[optional_key].default
      end

      REGEX_STUBS.keys.inject(pattern) do |p, key|
        p.gsub /:#{key}/, params[key].to_s
      end
    end
    alias :to_s :url_path

    def self.from_url_path(url_path)
      catch :route do
        Staticpress::Site.content_types.each do |content_type|
          if match = regex_for_pattern(config.routes[content_type.type]).match(url_path)
            params = { :content_type => content_type }
            match.names.each { |match_key| params[match_key.to_sym] = match[match_key] }
            route = new params
            throw :route, route if route.content
          end
        end

        nil
      end
    end

    def self.regex_for_pattern(pattern)
      regex = REGEX_STUBS.inject("^#{pattern}$") do |snip, (key, value)|
        snip.gsub /:#{key}/, value.regex.source
      end

      Regexp.new regex
    end
  end
end
