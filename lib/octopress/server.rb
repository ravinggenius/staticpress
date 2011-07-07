require 'tilt'

require 'octopress'
require 'octopress/configuration'
require 'octopress/error'

module Octopress
  class Server
    def initialize
      @content_dir = Octopress.blog_path + Octopress::Configuration.instance.source
    end

    def call(env)
      path = env['REQUEST_PATH']
      file = (@content_dir + path.sub('/', '')).expand_path

      if file.file?
        template = Tilt.new file
        body = template.render
        [ 200, {}, [ body ] ]
      else
        [ 404, {}, [] ]
      end
    end
  end
end
