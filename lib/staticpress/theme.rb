require 'hike'

module Staticpress
  class Theme
    extend Staticpress::Helpers
    include Staticpress::Helpers

    attr_reader :name, :root, :trail

    def initialize(name)
      @name = name.to_sym
      custom = Staticpress.blog_path + 'themes' + @name.to_s
      @root = custom.directory? ? custom : Staticpress.root + 'themes' + @name.to_s

      @trail = Hike::Trail.new
      @trail.append_paths custom, Staticpress.root + 'themes' + @name.to_s
      @trail.append_extensions *Tilt.mappings.keys
    end

    def ==(other)
      other.respond_to?(:name) ? (name == other.name) : super
    end

    def assets
      spider_map (root + 'assets').children do |file|
        file
      end.flatten
    end

    [
      :include,
      :layout,
      :view
    ].each do |method_name|
      define_method "#{method_name}_for" do |*names|
        names_with_default = (method_name == :include) ? names : names + [:default]
        catch :path do
          names_with_default.each do |name|
            path = trail.find "#{method_name}s/#{name}"
            throw :path, Pathname(path) if path
          end
          nil
        end
      end
    end

    def self.theme
      new config.theme
    end
  end
end
