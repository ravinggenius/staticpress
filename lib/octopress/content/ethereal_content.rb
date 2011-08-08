require 'octopress'
require 'octopress/content/base'

module Octopress::Content
  class EtherealContent < Base
    def exist?
      # FIXME determine if content really exist
      true
    end

    def template_path
      theme.layout_for(type)
    end

    def self.find_by_route(route)
      new(route, template_path.extname)
    end
  end
end
