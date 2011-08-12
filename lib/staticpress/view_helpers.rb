require 'staticpress'

module Staticpress
  class ViewHelpers
    attr_reader :theme

    def initialize(theme)
      @theme = theme
    end
  end
end
