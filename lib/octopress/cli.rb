require 'fileutils'
require 'pathname'
require 'rack'

require 'octopress'
require 'octopress/error'
require 'octopress/helpers'
require 'octopress/plugin'
require 'octopress/site'
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

create <title>
  create a new blog post

create_page <title> [path-in-content]
  create a new page in path-in-content

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
      Octopress.blog_path = destination

      FileUtils.mkdir_p Octopress.blog_path
      FileUtils.cp_r((Octopress.root + 'skeleton').children, Octopress.blog_path)

      config.title = if name.to_s.empty?
        Octopress.blog_path.basename.to_s.split('_').map(&:capitalize).join(' ')
      else
        name
      end

      config.save
    end

    # TODO get file extension from config
    def create(title)
      create_content do |now|
        created_on = "#{now.year}-#{'%02d' % now.month}-#{'%02d' % now.day}"
        name = title.gsub(/ /, '-').downcase
        filename = "#{created_on}-#{name}.#{config.preferred_format}"

        [
          Octopress::Content::Post.template,
          Octopress.blog_path + 'content' + '_posts' + filename
        ]
      end
    end

    # TODO get file extension from config
    def create_page(title, path = nil)
      create_content do |now|
        name = title.gsub(/ /, '-').downcase
        filename = "#{name}.#{config.preferred_format}".sub /^\//, ''

        [
          Octopress::Content::Page.template,
          Octopress.blog_path + 'content' + (path ? path : '') + filename
        ]
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
      Octopress::Plugin.activate_enabled
      Octopress::Site.new.save
    end

    def serve
      Octopress::Plugin.activate_enabled
      Rack::Server.new(:config => (Octopress.blog_path + 'config.ru').to_s, :Port => config.port).start
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

    protected

    # TODO write now to frontmatter as created_at
    def create_content(&block)
      now = Time.now.utc
      source, destination = block.call now
      FileUtils.mkdir_p destination.dirname
      destination.open('w') { |f| f.write source }
    end
  end
end
