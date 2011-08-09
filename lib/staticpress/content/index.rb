require 'staticpress'
require 'staticpress/content/ethereal_content'
require 'staticpress/route'

module Staticpress::Content
  class Index < EtherealContent
    def content
      { :text => '' }
    end

    def self.all
      []
    end
  end
end
