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
      @default ||= lambda do
        reply = YAML.load_file(Staticpress.root + 'skeleton' + 'config.yml')

        reply[:template_engine_options] ||= {}

        if defined? Compass
          [ :sass, :scss ].each do |template_engine|
            (reply[:template_engine_options][template_engine] ||= {}).merge!(Compass.sass_engine_options) do |key, first_choice, second_choice|
              reply[:template_engine_options][template_engine].key?(key) ? first_choice : second_choice
            end
          end
        end

        new reply
      end.call
    end

    def self.instance
      new(default.to_hash.merge(YAML.load_file(Staticpress.blog_path + 'config.yml')))
    end
  end
end
