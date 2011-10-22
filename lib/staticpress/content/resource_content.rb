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
  end
end
