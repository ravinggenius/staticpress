require 'staticpress'
require 'staticpress/content/base'

module Staticpress::Content
  class EtherealContent < Base
    def template_path
      self.class.template_path
    end

    def self.find_by_route(route)
      new(route, template_path.extname)
    end

    def self.template_path
      theme.view_for(type)
    end
  end
end
