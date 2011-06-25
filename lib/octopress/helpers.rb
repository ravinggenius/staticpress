module Octopress
  module Helpers
    def filename_options(title)
      t = Time.now.utc
      name = title.gsub(/ /, '-').downcase

      {
        :date => "#{t.year}-#{'%02d' % t.month}-#{'%02d' % t.day}",
        :year => t.year,
        :month => '%02d' % t.month,
        :day => '%02d' % t.day,
        :name => name
      }
    end
  end
end
