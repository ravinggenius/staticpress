require 'compass'
require 'haml'
require 'pathname'
require 'pry'
require 'redcarpet'
require 'sass'

require_relative '../lib/staticpress'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |path| require_relative path }

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

  config.include CustomMatchers
  config.include UnitSupport
  config.include IntegrationSupport
  config.extend BlogPathSetup
end
