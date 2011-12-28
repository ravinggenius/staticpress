require 'pathname'

require 'staticpress'
require 'staticpress/content/static_content'

module Staticpress::Content
  module ResourceContent
    def find_supported_extensions(path)
      file = path.file? ? path : Dir["#{path}.*"].first
      return [] if file.nil?

      # TODO stop looping when no more supported extensions
      Pathname(file).sub("#{file.to_s}.", '').to_s.split('.').map(&:to_sym).select do |extension|
        Staticpress::Content::StaticContent.supported_extensions.include? extension
      end.reverse
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
