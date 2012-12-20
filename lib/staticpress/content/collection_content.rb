module Staticpress::Content
  module CollectionContent
    def template_types
      find_supported_extensions template_path
    end

    def template_path
      theme.view_for(*preferred_layout_names)
    end
  end
end
