require 'fileutils'
require 'pathname'

require 'octopress'
require 'octopress/error'
require 'octopress/version'

module Octopress
  class CLI
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

    def post(title)
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
      FileUtils.cp_r((Octopress.root + 'skeleton' + name.to_s).children, destination)
    end
  end
end
