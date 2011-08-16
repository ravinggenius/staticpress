require 'staticpress'
require 'staticpress/error'
require 'staticpress/helpers'

module Staticpress
  class Route
    extend Staticpress::Helpers
    include Staticpress::Helpers

    REGEX_STUBS = {
      :date => /(?<date>\d{4}-\d{2}-\d{2})/,
      :year => /(?<year>\d{4})/,
      :month => /(?<month>\d{2})/,
      :day => /(?<day>\d{2})/,
      :slug => /(?<slug>[0-9a-z\-_\/]+)/,
      :title => /(?<title>[0-9a-z\-_]*)/,
      :name => /(?<name>[0-9a-z\-_]*)/,
      :number => /(?<number>\d+)/
    }

    attr_reader :params

    def initialize(params)
      @params = params
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
        snip.gsub /:#{key}/, value.source
      end

      Regexp.new regex
    end
  end
end
