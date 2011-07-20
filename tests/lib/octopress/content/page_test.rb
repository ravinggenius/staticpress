require_relative 'base_test'

class ContentPageTest < ContentBaseTest
  def setup
    @page = Octopress::Content::Page.new
  end
end
