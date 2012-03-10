require 'staticpress'
require 'staticpress/content/resource_content'

module Staticpress::Content
  module CollectionContent
    include ResourceContent

    def template_types
      find_supported_extensions template_path
    end

    def template_path
      theme.view_for(type) || theme.view_for(:default)
    end
  end
end
