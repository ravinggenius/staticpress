require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/route'

module Staticpress::Content
  class Theme < Base
    def self.all
      (Staticpress::Theme.theme.root + 'assets').children.map do |child|
        if child.directory?
          spider_directory child do |asset|
            find_by_path asset
          end
        else
          find_by_path child
        end
      end.flatten.compact
    end

    def self.find_by_path(path)
      stubs = Staticpress::Route::REGEX_STUBS
      regex = /^\/#{stubs[:theme].regex}\/assets\/#{stubs[:asset_type].regex}\/#{stubs[:slug].regex}/
      filename_parts = extensionless_path(path).to_s.sub((Staticpress.root + 'themes').to_s, '').match regex

      if path.file? && filename_parts
        params = {
          :content_type => self,
          :theme => filename_parts[:theme],
          :asset_type => filename_parts[:asset_type],
          :slug => filename_parts[:slug]
        }
        find_by_route Staticpress::Route.new(params)
      end
    end

    def self.find_by_route(route)
      return nil unless route

      catch :theme do
        supported_extensions.each do |extension|
          path = Staticpress::Theme.new(route.params[:theme]).root + 'assets' + route.params[:asset_type] + "#{route.params[:slug]}.#{extension}"
          throw :theme, new(route, path) if path.file?
        end

        nil
      end
    end
  end
end
