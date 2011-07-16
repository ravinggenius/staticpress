require 'pathname'

def run_recursively(dir)
  dir.children.each do |dir_or_test|
    if dir_or_test.directory?
      run_recursively dir_or_test
    elsif dir_or_test.to_s.end_with? '_test.rb'
      require_relative dir_or_test
    end
  end
end

run_recursively Pathname.new('tests/lib').expand_path
