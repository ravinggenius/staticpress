require 'octopress'
require 'octopress/error'
require 'octopress/site'

module Octopress
  class Server
    def initialize
      @site = Octopress::Site.new
    end

    def call(env)
      content = @site.find_content_by_url_path env['REQUEST_PATH']

      if content
        [ 200, { 'Content-Type' => 'text/html' }, [ content.render ] ]
      else
        [ 404, {}, [] ]
      end
    end
  end
end
