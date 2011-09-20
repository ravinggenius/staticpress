require 'staticpress'
require 'staticpress/plugin'
require 'staticpress/plugins'

module Staticpress
  class ViewHelpers
    attr_reader :theme

    def initialize(theme)
      @theme = theme
      Staticpress::Plugin.activate_enabled
      Staticpress::Plugins.constants.each { |plugin| include plugin }
    end

    def partial(name, locals = {})
      template_name = theme.include_for name
      if template_name.file?
        template = Tilt[template_name].new { template_name.read }
        template.render self.class.new(theme), locals
      end
    end
  end
end
