require 'tilt'

require 'octopress'
require 'octopress/helpers'

module Octopress
  class Theme
    include Octopress::Helpers

    attr_reader :root

    def initialize(name)
      @name = name
      custom = Octopress.blog_path + 'themes' + @name.to_s
      @root = custom.directory? ? custom : Octopress.root + 'themes' + @name.to_s
    end

    def layout_for(layout_name)
      keyed_layouts[layout_name.to_s]
    end

    def keyed_layouts
      Hash[layouts.map { |layout| [ extensionless_basename(layout), layout ] }]
    end

    def layouts
      (root + '_layouts').children
    end
  end
end
