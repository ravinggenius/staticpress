require 'bundler/gem_tasks'
require 'pathname'

task :default => [ :tests ]

desc 'Run all tests in path specified (defaults to tests). Tell Rake to start at a specific path with `rake tests[\'tests/lib/octopress/content\']`'
task :tests, :path do |t, args|
  args.with_defaults(:path => 'tests')

  run_recursively = lambda do |dir|
    Pathname.new(dir).expand_path.children.each do |dir_or_test|
      if dir_or_test.directory?
        run_recursively.call dir_or_test
      elsif dir_or_test.to_s.end_with? '_test.rb'
        require_relative dir_or_test
      end
    end
  end

  run_recursively.call args[:path]
end
