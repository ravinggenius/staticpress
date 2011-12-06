require 'staticpress'
require 'staticpress/content/static_content'

module Staticpress::Content
  module ResourceContent
    # FIXME add tests
    def find_supported_extension(extensionless_path)
      Staticpress::Content::StaticContent.supported_extensions.detect do |extension|
        extension.to_sym if Pathname.new("#{extensionless_path}.#{extension}").file?
      end
    end

    def gather_resources_from(paths)
      paths.map do |child|
        if child.directory?
          spider_directory child do |resource|
            find_by_path resource
          end
        else
          find_by_path child
        end
      end.flatten.compact
    end

    def load_resource(base, stub, params)
      catch :resource do
        Staticpress::Content::StaticContent.supported_extensions.each do |extension|
          path = base + "#{stub}.#{extension}"
          throw :resource, new(params) if path.file?
        end

        nil
      end
    end
  end
end
