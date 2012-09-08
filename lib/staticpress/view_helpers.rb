module Staticpress
  class ViewHelpers
    include Staticpress::Helpers

    attr_reader :meta, :page, :theme

    def initialize(page)
      @page = page
      @meta, @theme = page.meta, page.theme
      Staticpress::Plugin.activate_enabled
      class << self
        Staticpress::Plugins.constants.each do |plugin|
          include Staticpress::Plugins.const_get(plugin)
        end
      end
    end

    def partial(name, locals = {})
      template_name = theme.include_for name
      if template_name.file?
        template = Tilt[template_name].new { template_name.read }
        template.render self.class.new(page), locals
      end
    end

    # TODO site_meta should be an aggregate all metadata
    def site_meta
    end
  end
end
