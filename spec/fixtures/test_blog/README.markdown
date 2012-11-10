* copies lib/skeletons/new to <path-to-blog>
* this should edit the blog's config.yml to include [name-of-blog] (prompt for [name-of-blog] if blank)
$ staticpress new <path-to-blog> [name-of-blog]
$ cd <path-to-blog>

* copies <plugin-name> into <path-to-blog>/plugins/
$ staticpress fork_plugin <plugin-name>

* setting the theme is done in the main config file, this command is optional and
* just copies the theme's file into <path-to-blog>/themes/[theme-name] for customizations
* if [theme-name] is blank, default to the currently configured theme
$ staticpress fork_theme [theme-name]

* turn on local server for development
$ staticpress serve

* prepare blog for deployment
$ staticpress package

* deploy blog
$ staticpress deploy
