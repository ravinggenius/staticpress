require 'staticpress/booter'
require 'staticpress/server'

use Rack::ShowStatus
use Rack::ShowExceptions

# TODO run on configured port
run Staticpress::Server.new
