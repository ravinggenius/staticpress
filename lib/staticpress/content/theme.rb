require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/resource_content'
require 'staticpress/content/static_content'
require 'staticpress/route'

module Staticpress::Content
  class Theme < Base
    include StaticContent
    extend ResourceContent
    extend StaticContent

    def static?
      (Staticpress::Theme.new(route.params[:theme]).root + 'assets' + route.params[:asset_type] + route.params[:slug]).file?
    end

    def self.all
      gather_resources_from((Staticpress::Theme.theme.root + 'assets').children)
    end

    def self.find_by_path(path)
      if path.file?
        stubs = Staticpress::Route::REGEX_STUBS
        regex = /#{stubs[:theme].regex}\/assets\/#{stubs[:asset_type].regex}\/#{stubs[:slug].regex}/

        if filename_parts = parse_slug(path, (Staticpress.root + 'themes')).match(regex)
          params = {
            :content_type => self,
            :theme => filename_parts[:theme],
            :asset_type => filename_parts[:asset_type],
            :slug => filename_parts[:slug]
          }
          find_by_route Staticpress::Route.new(params)
        end
      end
    end

    def self.find_by_route(route)
      return nil unless route

      base = Staticpress::Theme.new(route.params[:theme]).root + 'assets' + route.params[:asset_type]
      path = base + route.params[:slug]
      return new(route, path) if path.file?

      catch :theme do
        supported_extensions.each do |extension|
          path = base + "#{route.params[:slug]}.#{extension}"
          throw :theme, new(route, path) if path.file?
        end

        nil
      end
    end
  end
end
