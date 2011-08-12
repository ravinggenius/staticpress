require_relative '../../../test_helper'

require 'staticpress/content/base'

class ContentBaseTest < TestHelper
  def setup
    Staticpress.blog_path = TEST_BLOG
  end

  def test_template_type
    assert_equal :haml, Staticpress::Content::Base.new(nil, :haml).template_type
    assert_equal :haml, Staticpress::Content::Base.new(nil, 'haml').template_type
    assert_equal :haml, Staticpress::Content::Base.new(nil, '.haml').template_type
  end
end
