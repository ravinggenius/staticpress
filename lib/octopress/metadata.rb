require 'octopress'
require 'octopress/js_object'

module Octopress
  class Metadata < JSObject
    def <<(other)
      self
    end
  end
end
