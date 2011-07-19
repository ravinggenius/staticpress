require 'octopress'
require 'octopress/content/base'

module Octopress::Content
  class Post < Base
    attr_reader :created_on

    def initialize(path)
      super

      parts = path.basename.to_s.match /(?<created_on>\d{4}-\d{2}-\d{2})-(?<route_title>.*)\./

      @created_on = Date.parse parts[:created_on]
      @route_title = parts[:route_title]
    end

    def self.all
      if (posts_dir = Octopress.blog_path + config.source + '_posts').directory?
        posts_dir.children.map { |post| new post }
      else
        []
      end
    end

    def self.create(format, title)
      now = Time.now.utc
      created_on = "#{now.year}-#{'%02d' % now.month}-#{'%02d' % now.day}"
      name = title.gsub(/ /, '-').downcase

      filename = "#{created_on}-#{name}.#{format}"
      destination = Octopress.blog_path + config.source + '_posts' + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.template
      now = Time.now.utc

      <<-TEMPLATE
---
created_at: #{now}
layout: default
---

in post
      TEMPLATE
    end
  end
end
