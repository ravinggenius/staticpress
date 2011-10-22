require 'staticpress'

module Staticpress::Content
  module StaticContent
    # layout not needed for binary files
    def layout
      static? ? nil : super
    end

    def parse_slug(path, base_path)
      path_string = path.to_s

      if supported_extensions.any? { |ext| path_string.end_with? ext.to_s }
        extensionless_path(path).to_s
      else
        path_string
      end.sub(base_path.to_s, '').sub(/^\//, '')
    end

    def render_partial(locals = {})
      static? ? template_path_content : super
    end
  end
end
