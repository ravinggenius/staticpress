require 'octopress'
require 'octopress/content/base'

module Octopress::Content
  class Post < Base
    attr_reader :created_on

    def initialize(path, theme)
      super

      parts = path.basename.to_s.match /(?<created_on>\d{4}-\d{2}-\d{2})-(?<route_title>.*)\./

      @created_on = Date.parse parts[:created_on]
      @route_title = parts[:route_title]
    end
  end
end
