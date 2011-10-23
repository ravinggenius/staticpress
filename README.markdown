## What is Staticpress?

Staticpress is a blog-focused static site generator. It uses Tilt for rendering nearly any template you can think of and come with a built-in Rack server for easy development previews.


## Getting Started

Staticpress is installable as a Rubygem so a simple `[sudo] gem install staticpress` is all you need. Once installed you will need to initialize your blog with `staticpress new <path-to-blog> [name-of-blog]`, where `<path-to-blog>` is a relative path to some directory and `[name-of-blog]` is an optional title. If the directory does not exist yet, it will be created, so go ahead and `cd` into it.

From your blog directory, you can create a new blog post with `staticpress create <title>`. You can turn on the server with `staticpress serve` to preview work in progress. Several other commands are available; check out `staticpress help` for more information.
