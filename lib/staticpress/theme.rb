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

    def ==(other)
      other.respond_to?(:root) ? (root == other.root) : super
    end

    [
      :include,
      :layout,
      :view
    ].each do |method_name|
      define_method "default_#{method_name}" do
        send("keyed_#{method_name}s")['default']
      end unless method_name == :include

      define_method "keyed_#{method_name}s" do
        hash_from_array(send("#{method_name}s")) { |name| extensionless_basename name }
      end

      define_method "#{method_name}_for" do |name|
        send("keyed_#{method_name}s")[name.to_s]
      end

      define_method "#{method_name}s" do
        (root + "#{method_name}s").children
      end
    end

    def self.theme
      new config.theme
    end
  end
end
