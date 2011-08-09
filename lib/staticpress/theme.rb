require 'tilt'

require 'staticpress'
require 'staticpress/helpers'

module Staticpress
  class Theme
    extend Staticpress::Helpers
    include Staticpress::Helpers

    attr_reader :root

    def initialize(name)
      @name = name
      custom = Staticpress.blog_path + 'themes' + @name.to_s
      @root = custom.directory? ? custom : Staticpress.root + 'themes' + @name.to_s
    end

    def default_layout
      keyed_layouts['default']
    end

    def layout_for(layout_name)
      keyed_layouts[layout_name.to_s] || default_layout
    end

    def keyed_layouts
      hash_from_array(layouts) { |layout| extensionless_basename layout }
    end

    def layouts
      (root + '_layouts').children
    end

    def self.theme
      @theme ||= new config.theme
    end
  end
end
