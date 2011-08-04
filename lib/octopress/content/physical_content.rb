require 'octopress'

module Octopress::Content
  module PhysicalContent
    def content
      return @content if @content

      regex_frontmatter = /^-{3}${1}(?<frontmatter>.*)^-{3}${1}/m
      regex_text = /(?<text>.*)/m
      regex = /#{regex_frontmatter}#{regex_text}/

      c = template_path_content
      @content = c.match(regex_frontmatter) ? c.match(regex) : c.match(regex_text)
    end

    def exist?
      template_path.file?
    end

    def template_path_content
      exist? ? template_path.read : ''
    end
  end
end
