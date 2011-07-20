require_relative 'base_test'

require 'octopress/content/page'

class ContentPageTest < ContentBaseTest
  def setup
    @page = Octopress::Content::Page.new
  end
end
