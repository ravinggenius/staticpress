require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/resource_content'
require 'staticpress/content/static_content'
require 'staticpress/route'

module Staticpress::Content
  class Theme < Base
    include ResourceContent
    include StaticContent
    extend ResourceContent
    extend StaticContent

    attr_reader :extension

    def initialize(params)
      super
      @extension = find_supported_extension template_path
    end

    def static?
      (Staticpress::Theme.new(params[:theme]).root + 'assets' + params[:asset_type] + params[:slug]).file?
    end

    def template_path
      slug = extension ? "#{params[:slug]}.#{extension}" : params[:slug]
      Staticpress::Theme.new(params[:theme]).root + 'assets' + params[:asset_type] + slug
    end

    def self.all
      gather_resources_from((Staticpress::Theme.theme.root + 'assets').children)
    end

    def self.find_by_path(path)
      if path.file?
        stubs = Staticpress::Route::REGEX_STUBS
        regex = /#{stubs[:theme].regex}\/assets\/#{stubs[:asset_type].regex}\/#{stubs[:slug].regex}/

        # FIXME send parse_slug something more intelligent as second parameter
        if match = regex.match(parse_slug(path, Staticpress.root + 'themes').first)
          new hash_from_match_data(match)
        end
      end
    end
  end
end
