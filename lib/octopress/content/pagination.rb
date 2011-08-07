require 'octopress'
require 'octopress/content/base'
require 'octopress/content/ethereal_content'
require 'octopress/route'

module Octopress::Content
  class Pagination < Base
    include Octopress::Content::EtherealContent

    def content
      { :text => '' }
    end

    def self.all
      []
    end
  end
end
