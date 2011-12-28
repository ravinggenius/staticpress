# Zero To Blogging

## Pre-requisites

Staticpress is written in Ruby, so the first thing you will need is a Ruby interpreter. Chances are you have one on your system already, but if not the [official site can get you setup](http://www.ruby-lang.org/en/). Ruby comes with a package manager called RubyGem (gem) that makes installing Ruby libraries (known as gems) super easy.

Once you have Ruby, open a terminal and type `gem install staticpress`. This command installs Staticpress so you can use it. Staticpress is a command line application, so leave your terminal open. If you ever get stuck and need a quick tip, run `staticpress help [task]`.

## Usage

When you want to create a new Staticpress blog, simply run `staticpress new <path-to-blog> [name-of-blog]`. Staticpress will create the `<path-to-blog>` for you if it does not exist. `[name-of-blog]` is optional. If you leave it out, Staticpress will make up a blog name from `<path-to-blog>`. Either way, `cd` into `<path-to-blog>`; this will be the place you need to be for all the other commands to work. By the way Staticpress uses several conventions to keep things simple. For instance many commands you are asked to type on the terminal take parameters. Required parameters will `<look-like-this>`, while optional parameters will `[look-like-this]`. You should not type the `<>` or `[]` symbols.

## Hello, World

After creating a new blog, you will probably want to create a new post. Type `staticpress create <title>` to create a new post. Staticpress will create a new empty post in `content/_posts/`. Open this file with your favorite text editor and start pontificating. When your are done, type `staticpress serve` to turn on the local development server. Open your favorite browser and navigate to [http://localhost:4000/](http://localhost:4000) to preview your post. Congratulations!
