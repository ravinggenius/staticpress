require 'bundler'

Bundler.require

require 'octopress/server'

use Rack::ShowStatus
use Rack::ShowExceptions

run Octopress::Server.new
