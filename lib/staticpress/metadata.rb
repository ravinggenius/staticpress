require 'staticpress'
require 'staticpress/js_object'

module Staticpress
  class Metadata < JSObject
    def <<(other)
      self
    end
  end
end
