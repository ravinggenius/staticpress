require 'staticpress'
require 'staticpress/content/base'

module Staticpress::Content
  class CollectionContent < Base
    def self.find_by_route(route)
      new(route, template_path)
    end

    def self.template_path
      theme.view_for(type) || theme.view_for(:default)
    end
  end
end
