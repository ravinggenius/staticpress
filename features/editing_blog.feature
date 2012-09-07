Feature: Editing blog

  Background:
    Given a blog exists

  Scenario: Creating a new blog post
    When I create a new post
    Then I can edit the post

  Scenario: Creating a static page
    When I create a new page
    Then I can edit the page

  Scenario: Copying a built-in plugin
    When I fork a plugin
    Then I can edit the forked plugin

  Scenario: Copying and renaming a built-in plugin
    When I fork and rename a plugin
    Then I can edit my plugin

  Scenario: Copying the default theme
    When I fork the default theme
    Then I can edit the theme files
