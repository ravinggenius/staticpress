require_relative '../test_helper'

require 'staticpress/server'

class ServerTest < TestHelper
  def setup
    super
    @server = Staticpress::Server.new
  end

  def test_call_root
    response = @server.call(env('/'))
    assert_equal 200, response.first
    assert_equal 'text/html', response[1]['Content-Type']
  end

  def test_call_image
    response = @server.call(env('/ruby.png'))
    assert_equal 200, response.first
    assert_equal 'image/png', response[1]['Content-Type']
  end
end
