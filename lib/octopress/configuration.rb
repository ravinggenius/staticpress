require 'ostruct'
require 'yaml'

require 'octopress'

module Octopress
  class Configuration < OpenStruct
    def to_hash
      @table.clone
    end

    def save
      (Octopress.blog_path + 'config.yml').open('w') { |f| YAML.dump(to_hash, f) }
    end

    def self.instance
      @config ||= new(YAML.load_file(Octopress.blog_path + 'config.yml'))
    end
  end
end
