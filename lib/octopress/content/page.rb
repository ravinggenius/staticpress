require 'octopress'
require 'octopress/content/base'

module Octopress::Content
  class Page < Base
    def self.create(format, title, path = nil)
      name = title.gsub(/ /, '-').downcase

      filename = "#{name}.#{format}"
      destination = Octopress.blog_path + 'content' + (path ? path : '').sub(/^\//, '') + filename

      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write template }
    end

    def self.template
      <<-TEMPLATE
---
layout: default
---

in page
      TEMPLATE
    end
  end
end
