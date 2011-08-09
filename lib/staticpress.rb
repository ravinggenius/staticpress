require 'pathname'

module Staticpress
  def self.blog_path
    Pathname.new(@path || '.').expand_path
  end

  def self.blog_path=(path)
    @path = path
  end

  def self.root
    Pathname.new File.expand_path('..', __FILE__)
  end
end
