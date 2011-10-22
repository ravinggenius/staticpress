require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/static_content'
require 'staticpress/route'

module Staticpress::Content
  class Theme < Base
    include StaticContent

    def static?
      (Staticpress::Theme.new(route.params[:theme]).root + 'assets' + route.params[:asset_type] + route.params[:slug]).file?
    end

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
      if path.file?
        stubs = Staticpress::Route::REGEX_STUBS
        regex = /#{stubs[:theme].regex}\/assets\/#{stubs[:asset_type].regex}\/#{stubs[:slug].regex}/
        path_string = path.to_s

        slug = if supported_extensions.any? { |ext| path_string.end_with? ext.to_s }
          extensionless_path(path).to_s
        else
          path_string
        end.sub((Staticpress.root + 'themes').to_s, '').sub(/^\//, '')

        if filename_parts = slug.match(regex)
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
