require 'octopress'
require 'octopress/error'
require 'octopress/site'

module Octopress
  class Server
    def initialize
      @site = Octopress::Site.new
    end

    def call(env)
      page = @site.find_page_by_route env['REQUEST_PATH']

      if page
        [ 200, { 'Content-Type' => 'text/html' }, [ page.render ] ]
      else
        [ 404, {}, [] ]
      end
    end
  end
end
