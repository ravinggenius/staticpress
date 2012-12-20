---
menu:
  position: 1.5
  text: Themes
---

# Themes

Themes determine the markup, look and behavior for a site. Markup is determined by Layouts and Views, while look and behavior is controlled via assets. Layouts provide general markup for the site title and global navigation. Views provide a template file for rendering generated content, such as a category page. Technically the `default` Layout and View are the only files required for a Theme, but providing a `post_paged` View is a good idea. Layouts and Views are looked up according to the preference table, however individual Posts and Pages can override their normal Layout by specifying `:layout` in frontmatter.

When rendering Staticpress selects an appropriate `template_path`, depending on what is being rendered. When a Page or Post is rendering (for instance `/about`), the `template_path` is the actual file in `content/` in the site. The Layout is selected according to the table, unless it is overridden on a case-by-case basis.

When Staticpress renders a generated page (for instance `/tags/programming`) the `template_path` is set to a View. The heuristic for selecting a View is the same as selecting a Layout. Again see the preference table.

Files inside the assets directory will be rendered similarly to static Page files when the site is generated or served. These files are pre-processed with Tilt (like all other files) so you can use whatever format you like.


## Layouts And Views Lookup

<table>
  <thead>
    <tr><th>File Name</th><th>Description</th><th>Example URL</th></tr>
  </thead>
  <tbody>
    <tr><td>page                                                   </td><td>a page (Layout only)                                                                   </td><td>/about</td></tr>
    <tr><td>post                                                   </td><td>a single post (Layout only)                                                            </td><td>/2012/11/10/hello</td></tr>
    <tr><td>category                                               </td><td>generated page for all categories                                                      </td><td>/categories</td></tr>
    <tr><td>tag                                                    </td><td>generated page for all tags                                                            </td><td>/tags</td></tr>
    <tr><td>post_paged                                             </td><td>use for paging through multiple posts                                                  </td><td>/page/3</td></tr>
    <tr><td>category_paged, post_paged                             </td><td>use for paging through multiple posts in a specific category                           </td><td>/categories/programming/page/2</td></tr>
    <tr><td>tag_paged, post_paged                                  </td><td>use for paging through multiple posts in a specific tag                                </td><td>/tags/ruby/page/1</td></tr>
    <tr><td>post_index, post_paged                                 </td><td>use for paging through multiple posts when no page is specified                        </td><td>/</td></tr>
    <tr><td>category_index, post_index, category_paged, post_paged </td><td>use for paging through multiple posts in a specific category when no page is specified </td><td>/categories/programming</td></tr>
    <tr><td>tag_index, post_index, tag_paged, post_paged           </td><td>use for paging through multiple posts in a specific tag when no page is specified      </td><td>/tags/ruby</td></tr>
    <tr><td>default                                                </td><td>used if more specific Layout or View is not available                                  </td><td></td></tr>
  </tbody>
</table>


## Minimal Theme Layout

    themes/<theme-name>/
    ├── assets/
    │   ├── fonts/
    │   ├── images/
    │   ├── scripts/
    │   │   └── application.js
    │   └── styles/
    │       └── application.css
    ├── layouts/
    │   └── default.extension
    └── views/
        ├── default.extension
        └── post_paged.extension
