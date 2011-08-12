require 'staticpress'
require 'staticpress/content/base'

module Staticpress::Content
  class EtherealContent < Base
    def self.find_by_route(route)
      new(route, template_path)
    end

    def self.template_path
      theme.view_for(type)
    end
  end
end
