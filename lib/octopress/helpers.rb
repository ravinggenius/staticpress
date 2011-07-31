require 'octopress'
require 'octopress/configuration'

module Octopress
  module Helpers
    def config
      Octopress::Configuration.instance
    end

    def extensionless_basename(pathname)
      path = pathname.basename.to_path
      path[0...(path.length - pathname.extname.length)]
    end

    def hash_from_array(array, &block)
      reply = array.map do |object|
        [ block.call(object), object ]
      end

      Hash[reply]
    end
  end
end
