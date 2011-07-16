require 'tilt'

require 'octopress'

module Octopress
  class Theme
    attr_reader :root

    def initialize(name)
      @name = name
      custom = Octopress.blog_path + 'themes' + @name.to_s
      @root = custom.directory? ? custom : Octopress.root + 'themes' + @name.to_s
    end

    def layout_for(layout_name)
      keyed_layouts[layout_name]
    end

    def keyed_layouts
      Hash[layouts.map { |layout| [ extensionless_basename(layout), layout ] }]
    end

    def layouts
      (root + '_layouts').children
    end

    def extensionless_basename(layout)
      path = layout.basename.to_path
      path[0...(path.length - layout.extname.length)]
    end
  end
end
