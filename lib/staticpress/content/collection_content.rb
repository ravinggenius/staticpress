require 'staticpress'

module Staticpress::Content
  module CollectionContent
    def find_by_route(route)
      new(route, template_path)
    end

    def template_path
      theme.view_for(type) || theme.view_for(:default)
    end
  end
end
