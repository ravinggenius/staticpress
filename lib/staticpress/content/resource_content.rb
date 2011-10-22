require 'staticpress'

module Staticpress::Content
  module ResourceContent
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

    def load_resource(route, base, stub)
      catch :resource do
        supported_extensions.detect do |extension|
          path = base + "#{stub}.#{extension}"
          throw :resource, new(route, path) if path.file?
        end

        nil
      end
    end
  end
end
