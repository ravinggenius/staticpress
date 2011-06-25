* copies lib/skeleton to <path-to-blog>
* this should edit the blog's config.yml to include [name-of-blog] (prompt for [name-of-blog] if blank)
$ octopress new <path-to-blog> [name-of-blog]
$ cd <path-to-blog>

* copies <plugin-name> into <path-to-blog>/plugins/
$ octopress fork_plugin <plugin-name>

* setting the theme is done in the main config file, this command is optional and
* just copies the theme's file into <path-to-blog>/themes/[theme-name] for customizations
* if [theme-name] is blank, default to the currently configured theme
$ octopress fork_theme [theme-name]

* turn on local server for development
$ octopress serve

* prepare blog for deployment
$ octopress package

* deploy blog
$ octopress deploy
