require 'staticpress'
require 'staticpress/configuration'

module Staticpress
  module Helpers
    def config
      Staticpress::Configuration.instance
    end

    def extensionless_basename(pathname)
      path = pathname.basename.to_path
      path[0...(path.length - pathname.extname.length)]
    end

    def extensionless_path(pathname)
      path = pathname.to_path
      Pathname.new path[0...(path.length - pathname.extname.length)]
    end

    def hash_from_array(array, &block)
      reply = array.map do |object|
        [ block.call(object), object ]
      end

      Hash[reply]
    end

    def paginate(range)
      reply = []

      def reply.[](*args)
        super || []
      end

      range_count = range.count
      per_page = config.posts_per_page
      array = range.to_a

      total_pages_count = (range_count / per_page) + ((range_count % per_page) == 0 ? 0 : 1)
      (0...total_pages_count).each do |number|
        reply << array[number * per_page, per_page]
      end

      reply
    end

    def spider_directory(dir, &block)
      dir.children.map do |child|
        if child.directory?
          spider_directory child, &block
        else
          block.call child
        end
      end
    end
  end
end
