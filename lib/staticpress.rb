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

require 'staticpress/js_object'
require 'staticpress/error'
require 'staticpress/helpers'
require 'staticpress/configuration'

require 'staticpress/content/resource_content'
require 'staticpress/content/collection_content'
require 'staticpress/content/static_content'

require 'staticpress/content/base'
require 'staticpress/content/category'
require 'staticpress/content/index'
require 'staticpress/content/page'
require 'staticpress/content/post'
require 'staticpress/content/tag'
require 'staticpress/content/theme'

require 'staticpress/cli'
require 'staticpress/integrations'
require 'staticpress/metadata'
require 'staticpress/plugin'
require 'staticpress/plugins'
require 'staticpress/pusher'
require 'staticpress/route'
require 'staticpress/server'
require 'staticpress/settings'
require 'staticpress/site'
require 'staticpress/theme'
require 'staticpress/version'
require 'staticpress/view_helpers'
