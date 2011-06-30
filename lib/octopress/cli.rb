require 'fileutils'
require 'pathname'

require 'octopress'
require 'octopress/configuration'
require 'octopress/content_type'
require 'octopress/error'
require 'octopress/helpers'
require 'octopress/version'

(Octopress.root + 'octopress' + 'content_types').children.each do |child|
  require child
end

module Octopress
  class CLI
    include Helpers

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

serve
  turn on local server for development

package
  prepare blog for deployment

deploy
  deploy blog

version
  display version
      MESSAGE
    end

    def new(destination, name = nil)
      dest = Pathname.new(destination).expand_path

      copy_skeleton :new, dest

      config = Octopress::Configuration.load

      config.title = if name.to_s.empty?
        dest.basename.to_s.split('_').map(&:capitalize).join(' ')
      else
        name
      end

      config.save
    end

    # content types are a bit messy to deal with. using classes to represent each content type
    # allows for future custom behavior to be added per type relatively easily. however this
    # introduces more issues when adding custom types (how to register new types?)
    #
    # alternatively a content type could be based simply on the files (including directories)
    # within user-configurable directory(ies). this would allow simple discovery of new types, but
    # would require the file name pattern for each type to be stored in the config
    def create(content_type, title)
      content_types = Octopress::ContentType.types
      type = content_type.to_sym

      if content_types.keys.include? type
        filename = content_types[type] % filename_options(title)
        copy_skeleton type, Octopress.blog_path + 'content' + "#{filename}.markdown"
      else
        raise Octopress::Error, 'Unknown content type'
      end
    end

    def fork_plugin(name, new_name = nil)
    end

    def fork_theme(name = nil)
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

    def copy_skeleton(name, destination)
      source = Octopress.root + 'skeletons' + name.to_s

      if source.directory?
        FileUtils.mkdir_p destination
        FileUtils.cp_r(source.children, destination)
      else
        FileUtils.mkdir_p destination.dirname
        FileUtils.cp(source, destination)
      end
    end
  end
end
