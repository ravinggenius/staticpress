require 'staticpress'
require 'staticpress/content/ethereal_content'
require 'staticpress/route'

module Staticpress::Content
  class Pagination < EtherealContent
    def sub_content
      Staticpress::Content::Post.all
    end

    def self.all
      page_numbers.map { |number| find_by_page_number number }
    end

    def self.page_numbers
      # TODO calculate total number of pages based on how many posts user configured to show per page
      total_count = Staticpress::Content::Post.all.count
      (1..total_count).to_a.map { |n| '%02d' % n } # TODO allow user to configure how many leading zeros pages should have (this only affects urls)
    end

    def self.find_by_page_number(number)
      find_by_route Staticpress::Route.new(:content_type => self, :number => number)
    end
  end
end
