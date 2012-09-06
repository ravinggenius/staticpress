# http://practicingruby.com/articles/shared/ozkzbsdmagcm

require 'fileutils'
require 'rack'
require 'thor'

module Staticpress
  class CLI < Thor
    include Thor::Actions
    include Staticpress::Helpers

    default_task :help

    map ['-h', '--help'] => :help
    map ['-v', '--version'] => :version

    class_option '--verbose', :type => :boolean, :default => false, :required => false, :desc => 'Output information as the task is running'

    def initialize(*args)
      super
      Staticpress::Settings.set! options
    end

    desc 'help [task]', 'Describe available tasks or one specific task'
    def help(*args)
      general_usage = <<-USAGE
Usage:
  staticpress <task> <required-argument> [option-argument] [--options...]

      USAGE
      puts general_usage if args.empty?
      super
    end

    desc 'new <path-to-blog> [name-of-blog]', 'Creates a new blog in <path-to-blog>'
    long_desc <<-DESCRIPTION
Creates a new blog in <path-to-blog>. <path-to-blog> will be created if it does
not exist, and files will be overwritten if they do exist
    DESCRIPTION
    def new(destination, name = nil)
      Staticpress.blog_path = destination

      FileUtils.mkdir_p Staticpress.blog_path
      FileUtils.cp_r((Staticpress.root + 'skeleton').children, Staticpress.blog_path)

      config = self.config.clone

      config.title = if name.to_s.empty?
        Staticpress.blog_path.basename.to_s.split('_').map(&:capitalize).join(' ')
      else
        name
      end

      config.save
    end

    desc 'create <title>', 'Create a new blog post'
    def create(title)
      Staticpress::Content::Post.create config.preferred_format, title
    end

    desc 'create_page <title> [path-in-content]', 'Create a new page in [path-in-content]'
    def create_page(title, path = nil)
      Staticpress::Content::Page.create config.preferred_format, title, path
    end

    desc 'fork_plugin <plugin-name> [new-plugin-name]', 'Copies <plugin-name> into <path-to-blog>/plugins/'
    long_desc <<-DESCRIPTION
Copies <plugin-name> into <path-to-blog>/plugins/. If [new-plugin-name] is
given, rename plugin in the destination. Be sure to activate the plugin
in config.yml
    DESCRIPTION
    def fork_plugin(name, new_name = nil)
      source = Staticpress::Plugin.find name

      destination_name = new_name ? (new_name.end_with?('.rb') ? new_name : "#{new_name}.rb") : source.basename
      destination = Staticpress.blog_path + (config.plugins_path || 'plugins') + destination_name

      FileUtils.mkdir_p destination.dirname
      FileUtils.cp source, destination
    end

    desc 'fork_theme [theme-name]', 'Copies [theme-name]\'s files into <path-to-blog>/themes/[theme-name]'
    long_desc <<-DESCRIPTION
Copies [theme-name]'s files into <path-to-blog>/themes/[theme-name] for
customizations. If [theme-name] is blank, copies the currently configured theme
    DESCRIPTION
    def fork_theme(name = nil)
      theme_name = name ? name : config.theme
      source = Staticpress.root + 'themes' + theme_name
      destination = Staticpress.blog_path + 'themes' + theme_name

      FileUtils.mkdir_p destination
      FileUtils.cp_r source.children, destination
    end

    desc 'list [method]', 'Send [method] to every content and output the result, or list all content if [method] is not present'
    def list(method = :to_s)
      Staticpress::Site.new.each do |content|
        puts(content.respond_to?(method) ? content.send(method) : content)
      end
    end

    desc 'build', 'Prepare blog for deployment'
    def build
      Staticpress::Site.new.save
    end

    desc 'serve', 'Turn on local server for development'
    def serve
      Rack::Server.new(:config => (Staticpress.blog_path + 'config.ru').to_s, :Port => config.port).start
    end

    desc 'push', 'Push blog to configured server'
    def push
      Staticpress::Pusher.push
    end

    desc 'deploy', 'Build blog and push in one step'
    def deploy
      build and push
    end

    desc 'version', 'Display version'
    def version
      puts "Staticpress #{Staticpress::Version}"
    end
  end
end
