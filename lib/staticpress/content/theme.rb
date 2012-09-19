module Staticpress::Content
  class Theme < Base
    include ResourceContent
    include StaticContent
    extend ResourceContent
    extend StaticContent

    def initialize(params)
      super
      @template_types = find_supported_extensions template_path
    end

    def static?
      (Staticpress::Theme.new(params[:theme]).root + 'assets' + params[:asset_type] + params[:slug]).file?
    end

    # https://github.com/sstephenson/hike
    def template_path
      Staticpress::Theme.new(params[:theme]).root + 'assets' + params[:asset_type] + "#{params[:slug]}#{template_extension}"
    end

    def self.all
      gather_resources_from((Staticpress::Theme.theme.root + 'assets').children)
    end

    def self.published
      all
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
