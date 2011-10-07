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

    [
      :include,
      :layout,
      :view
    ].each do |method_name|
      define_method "default_#{method_name}" do
        send("keyed_#{method_name}s")['default']
      end

      define_method "keyed_#{method_name}s" do
        hash_from_array(send("#{method_name}s")) { |name| extensionless_basename name }
      end

      define_method "#{method_name}_for" do |name|
        send("keyed_#{method_name}s")[name.to_s]
      end

      define_method "#{method_name}s" do
        (root + "_#{method_name}s").children
      end
    end

    remove_method :default_include

    def self.theme
      @theme ||= new config.theme
    end
  end
end
