require 'octopress'
require 'octopress/content/base'

module Octopress::Content
  class Page < Base
    def self.template
      <<-TEMPLATE
---
layout: default
---
in page
      TEMPLATE
    end
  end
end
