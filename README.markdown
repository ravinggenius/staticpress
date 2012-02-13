## What is Staticpress?

Staticpress is a blog-focused static site generator. It uses Tilt for rendering nearly any template you can think of and come with a built-in Rack server for easy development previews.


## Getting Started

Staticpress is installable as a Rubygem so a simple `[sudo] gem install staticpress` is all you need. Once installed you will need to initialize your blog with `staticpress new <path-to-blog> [name-of-blog]`, where `<path-to-blog>` is a relative path to some directory and `[name-of-blog]` is an optional title. If the directory does not exist yet, it will be created, so go ahead and `cd` into it.

From your blog directory, you can create a new blog post with `staticpress create <title>`. You can turn on the server with `staticpress serve` to preview work in progress. Several other commands are available; check out `staticpress help` for more information.


* .new passes params to #initialize
* #initialize manually calculates full path to template from params and populates @template_types
* Base#template_types is looped over in Base#render_partial
* Base#template_extension joins Base#template_types and prepends with . if not empty
* #template_path uses Base#template_extension to create full path to source


* http://jekyllbootstrap.com/
* http://vitobotta.com/how-to-migrate-from-wordpress-to-jekyll/
* http://vitobotta.com/sinatra-contact-form-jekyll/

* http://nanoc.stoneship.org/docs/
