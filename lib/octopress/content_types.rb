require 'octopress'

module Octopress
  class ContentTypes
    def self.all
      (Octopress.root + 'content_types').children.map do |child|
        child.basename.to_s.to_sym
      end
    end
  end
end
