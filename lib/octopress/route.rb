require 'octopress'
require 'octopress/error'
require 'octopress/helpers'

module Octopress
  class Route
    include Octopress::Helpers

    attr_reader :route

    def initialize(route)
      @route = route
    end

    def content
      catch :content do
        Octopress::Content::Base.content_types.each do |content_type|
          route_hash = regex_stubs.inject({}) do |reply, regex|
            match = route.match regex
            if match
              match.names.each { |match_key| reply[match_key.to_sym] = match[match_key] }
            end
            reply
          end

          content = content_type.find_by_route(route_hash)
          throw :content, content if content
        end
        nil
      end
    end

    def regex_stubs
      [
        /(?<date>\d{4}-\d{2}-\d{2})/,
        /(?<year>\d{4})/,
        /\d{4}\/(?<month>\d{2})/,
        /(?<day>\d{2})/,
        /^\/(?<slug>[0-9a-z\-_\/]*)$/,
        /(?<title>[0-9a-z\-_]*)$/
      ]
    end

    def to_path
      Octopress.blog_path + config.destination + route.sub(/^\//, '') + 'index.html'
    end
  end
end
