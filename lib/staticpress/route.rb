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
      :slug => /(?<slug>[0-9a-z\-_\/]*)/,
      :title => /(?<title>[0-9a-z\-_]*)/,
      :name => /(?<name>[0-9a-z\-_]*)/,
      :number => /(?<number>\d+)/
    }

    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def ==(other)
      params == other.params
    end

    def content
      params[:content_type].find_by_route self if params.key? :content_type
    end

    def inspect
      parts = [
        ("url_path=#{url_path}" if url_path),
        ("content_type=#{params[:content_type]}" if params.key? :content_type)
      ].compact

      p = Hash[self.params.clone.sort]
      p.delete :content_type
      parts << "params=#{p}"

      "#<#{self.class} #{parts.join ', '}>"
    end
    alias :to_s :inspect

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
      # TODO get index filename from config
      return nil unless url_path
      Staticpress.blog_path + config.destination + url_path.sub(/^\//, '') + 'index.html'
    end

    def url_path
      return nil unless params[:content_type]
      REGEX_STUBS.keys.inject(config.routes[params[:content_type].type].clone) do |pattern, key|
        pattern.gsub /:#{key}/, params[key].to_s
      end
    end

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
        
        new # if we don't find a route that matches anything, return an empty route
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
