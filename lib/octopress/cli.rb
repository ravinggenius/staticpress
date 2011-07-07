require 'fileutils'
require 'pathname'

require 'octopress'
require 'octopress/content_types'
require 'octopress/error'
require 'octopress/helpers'
require 'octopress/plugin'
require 'octopress/version'

module Octopress
  class CLI
    include Octopress::Helpers

    # TODO allow for more detailed help for each command
    def help
      puts <<-MESSAGE
USAGE: octopress <command> <required-argument> [option-argument]

COMMANDS:

help
  show this message

new <path-to-blog> [name-of-blog]
  creates a new blog in <path-to-blog>. <path-to-blog> will be created if it
  does not exist, and files will be overwritten if they do exist

create <content-type> <title>
  create a new piece of content

fork_plugin <plugin-name> [new-plugin-name]
  copies <plugin-name> into <path-to-blog>/plugins/. if [new-plugin-name] is
  given, rename plugin

fork_theme [theme-name]
  copies [theme-name]'s files into <path-to-blog>/themes/[theme-name] for
  customizations. if [theme-name] is blank, copies the currently configured
  theme

build
  prepare blog for deployment

serve
  turn on local server for development

push
  push blog to configured server

deploy
  build blog and push in one step

version
  display version
      MESSAGE
    end

    def new(destination, name = nil)
      dest = Pathname.new(destination).expand_path

      FileUtils.mkdir_p dest
      FileUtils.cp_r((Octopress.root + 'skeleton').children, dest)

      config.title = if name.to_s.empty?
        dest.basename.to_s.split('_').map(&:capitalize).join(' ')
      else
        name
      end

      config.save
    end

    # TODO allow custom content types
    # each content type would require an entry in config.yml
    def create(content_type, title)
      content_types = Octopress::ContentTypes.all
      type = content_type.to_sym

      if content_types.include? type
        filename = config.send("content_type_#{type}") % filename_options(title)

        source = Octopress.root + 'content_types' + type.to_s
        destination = Octopress.blog_path + 'content' + "#{filename}.markdown"

        FileUtils.mkdir_p destination.dirname
        FileUtils.cp(source, destination)
      else
        raise Octopress::Error, 'Unknown content type'
      end
    end

    def fork_plugin(name, new_name = nil)
      source = Octopress::Plugin.find name

      destination_name = new_name ? (new_name.end_with?('.rb') ? new_name : "#{new_name}.rb") : source.basename
      destination = Octopress.blog_path + (config.plugins_path || 'plugins') + destination_name

      FileUtils.mkdir_p destination.dirname
      FileUtils.cp source, destination
    end

    def fork_theme(name = nil)
      theme_name = name ? name : config.theme
      source = Octopress.root + 'themes' + theme_name
      destination = Octopress.blog_path + 'themes' + theme_name

      FileUtils.mkdir_p destination
      FileUtils.cp_r source.children, destination
    end

    def build
    end

    def serve
    end

    def push
    end

    def deploy
      build
      push
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
  end
end
