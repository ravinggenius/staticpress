require 'octopress'

module Octopress::Content
  module EtherealContent
    def exist?
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
