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
      file_name = (@content_dir + path.sub('/', '')).expand_path

      if file_name.file?
        template = Tilt.new file_name.to_s
        body = template.render
        [ 200, { 'Content-Type' => 'text/html' }, [ body ] ]
      else
        [ 404, {}, [] ]
      end
    end
  end
end
