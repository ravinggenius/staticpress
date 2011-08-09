require 'staticpress'
require 'staticpress/error'
require 'staticpress/helpers'

module Staticpress
  module Plugin
    extend Staticpress::Helpers

    def self.activate_enabled
      config.plugins.each do |plugin_name|
        require find(plugin_name).to_s
      end
    end

    def self.find(name)
      file_name = name.end_with?('.rb') ? name : "#{name}.rb"

      plugin_locations.each do |location|
        file = location + file_name
        return file if file.file?
      end

      raise Staticpress::Error, "Plugin not found: #{file.basename}"
    end

    def self.plugin_locations
      [
        ((Staticpress.blog_path + config.plugins_path) if config.plugins_path),
        (Staticpress.root + 'staticpress' + 'plugins')
      ].compact
    end
  end
end
