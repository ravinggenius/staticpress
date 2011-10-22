require 'staticpress'

module Staticpress::Content
  module StaticContent
    # layout not needed for binary files
    def layout
      static? ? nil : super
    end

    def render_partial(locals = {})
      static? ? template_path_content : super
    end
  end
end
