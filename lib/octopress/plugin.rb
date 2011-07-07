require 'octopress'
require 'octopress/error'
require 'octopress/helpers'

module Octopress
  module Plugin
    extend Octopress::Helpers

    def self.activate
      config.plugins.each do |plugin_name|
        require find(plugin_name)
      end
    end

    def self.find(name)
      file_name = name.end_with?('.rb') ? name : "#{name}.rb"

      plugin_locations.each do |location|
        file = location + file_name
        return file if file.file?
      end

      raise Octopress::Error, "Plugin not found: #{file.basename}"
    end

    def self.plugin_locations
      [
        ((Octopress.blog_path + config.plugins_path) if config.plugins_path),
        (Octopress.root + 'octopress' + 'plugins')
      ].compact
    end
  end
end
