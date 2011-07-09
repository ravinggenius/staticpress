require 'octopress/server'

use Rack::ShowStatus
use Rack::ShowExceptions

# TODO run on configured port
run Octopress::Server.new
