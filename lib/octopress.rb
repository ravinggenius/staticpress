require 'pathname'

module Octopress
  def root
    Pathname.new('..').expand_path
  end
end
