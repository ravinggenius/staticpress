require 'pathname'

require 'octopress'

module Octopress
  class CLI
    def help
      puts <<-MESSAGE
Help message goes here
      MESSAGE
    end

    def new(destination, name = destination)
      source = Octopress.root + 'lib' + 'skeleton'
      blog_name = Pathname.new(name).expand_path.basename.split('_').map(&:capitalize).join(' ')
      FileUtils.cp_r source, Pathname.new(destination).expand_path
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
    end

    def self.run
      puts ARGV

      cli = new
      command = (ARGV.first || :help).to_sym

      case command
      when :new
        cli.new ARGV[1], ARGV[2]
      when :fork_plugin, :fork_theme
        cli.send command, ARGV[1]
      when :serve, :package, :deploy, :version
        cli.send command
      else
        cli.help
      end
    end

    protected

    def blog_path
      Pathname.new('.').expand_path
    end
  end
end
