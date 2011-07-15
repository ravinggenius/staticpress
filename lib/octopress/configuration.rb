require 'yaml'

require 'octopress'
require 'octopress/js_object'

module Octopress
  class Configuration < JSObject
    def save
      (Octopress.blog_path + 'config.yml').open('w') { |f| YAML.dump(to_hash, f) }
    end

    def self.instance
      @config ||= new(YAML.load_file(Octopress.blog_path + 'config.yml'))
    end
  end
end
