require 'octopress'
require 'octopress/error'
require 'octopress/helpers'

module Octopress
  class Route
    include Octopress::Helpers

    attr_reader :params, :url_path

    def initialize(params)
      @params = params
    end

    def ==(other)
      params == other.params
    end

    def content
      params[:content_type].find_by_route self if params.key? :content_type
    end

    def inspect
      parts = [ "url_path=#{url_path}" ]

      parts << "content_type=#{params[:content_type]}" if params.key? :content_type

      p = Hash[self.params.clone.sort]
      p.delete :url_path
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
      # TODO get index filename from config
      Octopress.blog_path + config.destination + url_path.sub(/^\//, '') + 'index.html'
    end

    def url_path
      # TODO create url_path from parts in params according to pattern from content_type
      params[:url_path] || '/'
    end

    def self.from_url_path(url_path)
      catch :params do
        Octopress::Content::Base.content_types.each do |content_type|
          params = regex_stubs.inject({ :content_type => content_type, :url_path => url_path }) do |reply, regex|
            match = url_path.match regex
            if match
              match.names.each { |match_key| reply[match_key.to_sym] = match[match_key] }
            end
            reply
          end

          route = new params
          throw :params, route if route.content
        end
        
        new({ :url_path => url_path }) # if we don't find a route that matches anything, return an empty route
      end
    end

    def self.regex_stubs
      [
        /(?<date>\d{4}-\d{2}-\d{2})/,
        /(?<year>\d{4})/,
        /\d{4}\/(?<month>\d{2})/,
        /(?<day>\d{2})/,
        /^\/(?<slug>[0-9a-z\-_\/]*)$/,
        /(?<title>[0-9a-z\-_]*)$/
      ]
    end
  end
end
