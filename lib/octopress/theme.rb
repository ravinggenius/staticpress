require 'tilt'

require 'octopress'

module Octopress
  class Theme
    attr_reader :root

    def initialize(name)
      @name = name
      custom = Octopress.blog_path + 'themes' + @name
      @root = custom.directory? ? custom : Octopress.root + 'themes' + @name
    end

    def layout_for(layout_name)
      layouts.detect do |layout|
        "#{layout.basename}." == "#{layout_name}."
      end || layouts_dir + 'default'
    end

    def layouts
      layouts_dir.children
    end

    def layouts_dir
      root + '_layouts'
    end
  end
end
