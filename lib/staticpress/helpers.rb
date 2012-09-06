require 'pathname'

module Staticpress
  module Helpers
    def config
      Staticpress::Configuration.instance
    end

    def extensionless_basename(pathname)
      extensionless_path(pathname).basename.to_s
    end

    def extensionless_path(pathname)
      pathname.sub(pathname.extname, '')
    end

    def hash_from_array(array, &block)
      reply = array.map do |object|
        [ block.call(object), object ]
      end

      Hash[reply]
    end

    def hash_from_match_data(match)
      Hash[match.names.map { |match_key| [match_key.to_sym, match[match_key]] }]
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

    def settings
      Staticpress::Settings.instance
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

    def titleize(url_path)
      url_path.sub(/^\//, '').split(/\//).map do |phrase|
        phrase.split(/-/).map(&:capitalize).join(config.title_separators.word)
      end.join(config.title_separators.phrase)
    end
  end
end
