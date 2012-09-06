ENV['BUNDLE_GEMFILE'] ||= File.expand_path('./Gemfile')

if File.exists?(ENV['BUNDLE_GEMFILE'])
  require 'bundler'

  Bundler.require
end

require 'pathname'

module Staticpress
  def self.blog_path
    Pathname(@path || '.').expand_path
  end

  def self.blog_path=(path)
    @path = path
  end

  def self.root
    Pathname File.expand_path('..', __FILE__)
  end
end

require_relative 'staticpress/js_object'
require_relative 'staticpress/error'
require_relative 'staticpress/helpers'
require_relative 'staticpress/configuration'

require_relative 'staticpress/content/resource_content'
require_relative 'staticpress/content/collection_content'
require_relative 'staticpress/content/static_content'

require_relative 'staticpress/content/base'
require_relative 'staticpress/content/category'
require_relative 'staticpress/content/index'
require_relative 'staticpress/content/page'
require_relative 'staticpress/content/post'
require_relative 'staticpress/content/tag'
require_relative 'staticpress/content/theme'

require_relative 'staticpress/cli'
require_relative 'staticpress/integrations'
require_relative 'staticpress/metadata'
require_relative 'staticpress/plugin'
require_relative 'staticpress/plugins'
require_relative 'staticpress/pusher'
require_relative 'staticpress/route'
require_relative 'staticpress/server'
require_relative 'staticpress/settings'
require_relative 'staticpress/site'
require_relative 'staticpress/theme'
require_relative 'staticpress/version'
require_relative 'staticpress/view_helpers'
