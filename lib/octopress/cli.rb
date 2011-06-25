require 'fileutils'
require 'pathname'

require 'octopress'
require 'octopress/content_type'
require 'octopress/error'
require 'octopress/helpers'
require 'octopress/version'

(Octopress.root + 'octopress' + 'content_types').children.each do |child|
  require child
end

module Octopress
  class CLI
    extend Helpers

    def help
      puts <<-MESSAGE
Help message goes here
      MESSAGE
    end

    def new(destination, name = nil)
      dest = Pathname.new(destination).expand_path

      # TODO do something with blog_name
      blog_name = if name.to_s.empty?
        dest.basename.to_s.split('_').map(&:capitalize).join(' ')
      else
        name
      end

      copy_skeleton :new, dest
    end

    def create(content_type, title)
      content_types = Octopress::ContentType.types
      type = content_type.to_sym

      if content_types.keys.include? type
        filename = content_types[type] % filename_options(title)
        copy_skeleton type, blog_path + 'content' + "#{filename}.markdown"
      else
        raise Octopress::Error, 'Unknown content type'
      end
    end

    def fork_plugin
    end

    def fork_theme
    end

    def serve
    end

    def package
    end

    def deploy
    end

    def version
      puts "Octopress #{Octopress::Version}"
    end

    def self.run
      cli = new
      command = (ARGV.first || :help).to_sym

      if cli.respond_to? command
        cli.send command, *ARGV[1..-1]
      else
        cli.help
      end
    end

    protected

    def blog_path
      Pathname.new('.').expand_path
    end

    def copy_skeleton(name, destination)
      FileUtils.cp_r((Octopress.root + 'skeletons' + name.to_s).children, destination)
    end
  end
end
