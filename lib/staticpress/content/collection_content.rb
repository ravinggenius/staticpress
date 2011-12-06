require 'staticpress'

module Staticpress::Content
  module CollectionContent
    def template_path
      theme.view_for(type) || theme.view_for(:default)
    end
  end
end
