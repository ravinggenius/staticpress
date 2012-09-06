require 'tilt'

module Staticpress::Content
  module StaticContent
    # layout not needed for binary files
    def layout
      static? ? nil : super
    end

    def parse_slug(path, base_path)
      path_string = path.to_s

      clean = lambda { |str| str.sub(base_path.to_s, '').sub(/^\//, '') }

      if Staticpress::Content::StaticContent.supported_extensions.any? { |ext| path_string.end_with? ext.to_s }
        [ clean.call(extensionless_path(path).to_s), path.extname.sub(/^\./, '').to_sym ]
      else
        [ clean.call(path_string), nil ]
      end
    end

    def render_partial(locals = {})
      static? ? template_path_content : super
    end

    def self.supported_extensions
      Tilt.mappings.keys.reject { |mapping| mapping == '' }.map &:to_sym
    end
  end
end
