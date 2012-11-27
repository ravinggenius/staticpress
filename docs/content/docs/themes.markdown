---
menu:
  position: 1.5
  text: Themes
---

# Themes

Themes determine the markup, styles and behavior for a site. Rendered markup is determined by layouts and views. At a minimum Themes should provide the :default layout, the :default view and the :index view.


### Layouts

Layouts are found according to the table below. If any layout does not exist, the default layout will be used if it is available. Individual posts and pages can override the layout by specifying the layout in frontmatter.

    single page => :page_single, :default
    single post => :post_single, :default

Layouts for wrapping multiple posts views

    multiple posts => :index, :default
    multiple posts (category) => :category, then same as multiple posts
    multiple posts (tag) => :tag, then same as multiple posts


### Views

Views are used to determine how pages and posts are rendered inside a layout. They have a similar lookup heuristic as layouts. Default views are not as useful, as they should be tailored for pages or posts

    full page => :page_full, :default
    full post => :post_full, :default
    preview posts => :post_preview, :post_full, :default

Views for wrapping other views

    multiple posts => :index, :default
    multiple posts (category) => :category_index, then same as multiple posts
    multiple posts (tag) => :tag_index, then same as multiple posts


### Rendering

The above might be more clearly demonstrated below. Parenthesis indicate the order files are preferred, assuming default behavior is not overridden.

Single page

    layout(:page_single, :default)
      view(:page_full, :default)

Single post

    layout(:post_single, :default)
      view(:post_full, :default)

Multiple posts (/page/:n)

    layout(:index, :default)
      view(:index)
        view(:post_preview, :post_full, :default)     <-- this view gets repeated for every post

Multiple posts with category (/category/:category/page/:n)

    layout(:category, :default)
      view(:category_index, :index)
        view(:post_preview, :post_full, :default)     <-- this view gets repeated for every post

Multiple posts with tag (/tag/:tag/page/:n)

    layout(:tag, :default)
      view(:tag_index, :index)
        view(:post_preview, :post_full, :default)     <-- this view gets repeated for every post
