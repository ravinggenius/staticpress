require 'staticpress'
require 'staticpress/error'
require 'staticpress/site'

module Staticpress
  class Server
    def initialize
      @site = Staticpress::Site.new
    end

    def call(env)
      content = @site.find_content_by_url_path env['REQUEST_PATH']

      if content
        [ 200, { 'Content-Type' => content.content_type }, [ content.render ] ]
      else
        [ 404, {}, [] ]
      end
    end
  end
end
