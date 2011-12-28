require 'pathname'

module Staticpress
  def self.blog_path
    Pathname(@path || '.').expand_path
  end

  def self.blog_path=(path)
    @path = path
  end

  def self.root
    Pathname File.expand_path('..', __FILE__)
  end
end
