require 'yaml'

module Staticpress
  # IDEA look into configatron https://github.com/markbates/configatron
  # FIXME this class is hard to test
  class Configuration < JSObject
    def save
      (Staticpress.blog_path + 'config.yml').open('w') do |f|
        custom_values = self - self.class.default
        YAML.dump(custom_values.to_hash, f)
      end
    end

    def self.default
      @default ||= new(YAML.load_file(Staticpress.root + 'skeleton' + 'config.yml'))
    end

    def self.instance
      new(default.to_hash.merge(YAML.load_file(Staticpress.blog_path + 'config.yml')))
    end
  end
end
