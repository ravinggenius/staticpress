require 'spec_helper'

describe Staticpress::Server do
  basic_blog

  let(:server) { Staticpress::Server.new }

  describe 'GET /' do
    it '...' do
      response = server.call(env('/'))
      expect(response.first).to eq(200)
      expect(response[1]['Content-Type']).to eq('text/html')
    end
  end

  describe 'GET /ruby.png' do
    it '...' do
      response = server.call(env('/ruby.png'))
      expect(response.first).to eq(200)
      expect(response[1]['Content-Type']).to eq('image/png')
    end
  end
end
