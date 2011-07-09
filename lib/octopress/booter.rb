ENV['BUNDLE_GEMFILE'] ||= File.expand_path('./Gemfile')

if File.exists?(ENV['BUNDLE_GEMFILE']) && !defined? Bundler
  require 'bundler'

  Bundler.require
end
