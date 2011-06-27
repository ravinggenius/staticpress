require 'ostruct'
require 'yaml'

require 'octopress'

module Octopress
  class Configuration < OpenStruct
    CONFIG_FILE = Octopress.blog_path + 'config.yml'

    def save
      CONFIG_FILE.open('w') { |f| YAML.dump(instance_variable_get('@table'), f) }
    end

    def self.load
      new(CONFIG_FILE.file? ? YAML.load_file(CONFIG_FILE) : {})
    end
  end
end