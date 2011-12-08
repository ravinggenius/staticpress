require 'staticpress'
require 'staticpress/helpers'

module Staticpress
  module Route
    extend Staticpress::Helpers

    RegexStub = Struct.new :klass, :regex

    REGEX_STUBS = {
      :asset_type => RegexStub.new(:string,  /(?<asset_type>fonts|images|scripts|styles)/),
      :date       => RegexStub.new(:date,    /(?<date>\d{4}-\d{2}-\d{2})/),
      :year       => RegexStub.new(:string,  /(?<year>\d{4})/),
      :month      => RegexStub.new(:string,  /(?<month>\d{2})/),
      :day        => RegexStub.new(:string,  /(?<day>\d{2})/),
      :slug       => RegexStub.new(:string,  /(?<slug>[0-9a-z\-_\.\/]*)/),
      :title      => RegexStub.new(:string,  /(?<title>[0-9a-z\-_]*)/),
      :name       => RegexStub.new(:string,  /(?<name>[0-9a-z\-_]*)/),
      :number     => RegexStub.new(:integer, /(?<number>\d+)/),
      :theme      => RegexStub.new(:string,  /(?<theme>[0-9a-z\-_]*)/)
    }

    def self.extract_params(pattern, url_path)
      if match = regex_for_pattern(pattern).match(url_path)
        hash_from_match_data match
      end
    end

    def self.regex_for_pattern(pattern)
      regex = REGEX_STUBS.inject("^#{pattern}$") do |snip, (key, value)|
        snip.gsub /:#{key}/, value.regex.source
      end

      Regexp.new regex
    end

    def self.route_options(title)
      t = Time.now.utc

      {
        :date => "#{t.year}-#{'%02d' % t.month}-#{'%02d' % t.day}",
        :year => t.year,
        :month => '%02d' % t.month,
        :day => '%02d' % t.day,
        :title => title
      }
    end
  end
end
