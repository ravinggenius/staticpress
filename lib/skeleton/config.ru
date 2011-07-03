require 'bundler/setup'
require 'rack'

# TODO look into Rack::Static
# https://github.com/craigmarksmith/rack-directory-index/
module Rack
  class DirectoryIndex
    def initialize(app)
      @app = app
    end

    def call(env)
      index_path = Octopress.blog_path + 'public' + Rack::Request.new(env).path + 'index.html'
      if index_path.file?
        [200, {'Content-Type' => 'text/html'}, [index_path.read]]
      else
        @app.call(env)
      end
    end
  end
end

use Rack::ShowStatus      # Nice looking 404s and other messages
use Rack::ShowExceptions  # Nice looking errors

use Rack::DirectoryIndex

run Rack::Directory.new(Octopress.blog_path + 'public')
