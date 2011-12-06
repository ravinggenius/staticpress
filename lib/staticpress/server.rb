require 'staticpress'
require 'staticpress/error'
require 'staticpress/site'

module Staticpress
  class Server
    def initialize
      @site = Staticpress::Site.new
    end

    def call(env)
      if content = @site.find_content_by_env(env)
        [ 200, { 'Content-Type' => content.content_type }, [ content.render ] ]
      else
        [ 404, {}, [] ]
      end
    end
  end
end
