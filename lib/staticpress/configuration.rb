require 'yaml'

require 'staticpress'
require 'staticpress/js_object'

module Staticpress
  class Configuration < JSObject
    def save
      (Staticpress.blog_path + 'config.yml').open('w') { |f| YAML.dump(to_hash, f) }
    end

    def self.instance
      @config ||= new(YAML.load_file(Staticpress.blog_path + 'config.yml'))
    end
  end
end
