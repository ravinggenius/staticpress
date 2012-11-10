require 'compass'
require 'debugger'
require 'haml'
require 'pathname'
require 'redcarpet'
require 'sass'

require_relative '../lib/staticpress'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :blur => true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.include UnitSupport
  config.include IntegrationSupport

  TEST_BLOG = (Staticpress.root + '..' + 'tests' + 'test_blog').expand_path

  before :each do
    Staticpress.blog_path = TEST_BLOG
  end

  after :each do
    Staticpress.blog_path = '.'
    test_blog_public = TEST_BLOG + 'public'
    FileUtils.rm_rf test_blog_public if test_blog_public.directory?
  end
end
