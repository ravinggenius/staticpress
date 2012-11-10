require 'spec_helper'

describe Staticpress::Server do
  let(:server) { Staticpress::Server.new }

  describe 'GET /' do
    it '...' do
      response = server.call(env('/'))
      assert_equal 200, response.first
      assert_equal 'text/html', response[1]['Content-Type']
    end
  end

  describe 'GET /ruby.png' do
    it '...' do
      response = server.call(env('/ruby.png'))
      assert_equal 200, response.first
      assert_equal 'image/png', response[1]['Content-Type']
    end
  end
end
