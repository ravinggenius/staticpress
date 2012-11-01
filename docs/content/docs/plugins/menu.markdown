---
menu:
  position: 1.6.0
  text: Menu
---

# Menu

Frontmatter menu key

* adding `menu` to a page's frontmatter causes the page to be available to the menu system
* `text` subkey can be used to specify alternate menu text, otherwise the page's natural title will be used
* menu items are ordered alphabetically unless overridden by `position`
* `position`, when specified, allows the menu item to be moved around
* `position` can be used to build a menu tree of arbitrary depth
* `position` is zero-based
  * `position: 2`   # third menu item
  * `position: 2.1` # second submenu item under third menu item
* if `position` is negative, position menu item relative to the end, instead of the start
