Feature: The happy path

  Scenario: Some basic commands
    Given I run `staticpress help`
    Then the exit status should be 0
    And the output should contain "Usage"

    Given I run `staticpress version`
    Then the exit status should be 0
    And the output should contain "Staticpress"

  Scenario: Creating a new blog
    When I run `staticpress new my_new_blog`
    Then the following files should exist:
      | my_new_blog/config.ru       |
      | my_new_blog/config.yml      |
      | my_new_blog/Gemfile         |
      | my_new_blog/README.markdown |

  Scenario: Creating a new blog with a custum title
    When I run `staticpress new my_new_blog 'This is my blog'`
    Then the file "my_new_blog/config.yml" should contain exactly:
      """
      ---
      :title: This is my blog

      """

  Scenario: Creating a new blog post
    Given a blog exists
    When I run `staticpress create 'Hello World'`
    Then a directory named "content/_posts" should exist
    And a post named "hello-world" should exist

  Scenario: Creating a static page
    Given a blog exists
    When I run `staticpress create_page about`
    Then a directory named "content" should exist
    And a file named "content/about.markdown" should exist

  Scenario: Copying a built-in plugin
    Given a blog exists
    When I run `staticpress fork_plugin blockquote`
    Then a directory named "plugins" should exist
    And a file named "plugins/blockquote.rb" should exist

  Scenario: Copying and renaming a built-in plugin
    Given a blog exists
    When I run `staticpress fork_plugin blockquote pullquote`
    Then a directory named "plugins" should exist
    And a file named "plugins/pullquote.rb" should exist
    And a file named "plugins/blockquote.rb" should not exist

  Scenario: Copying the default theme
    Given a blog exists
    When I run `staticpress fork_theme`
    Then a directory named "themes" should exist
    And a directory named "themes/basic" should exist

  Scenario: Listing all routes
    Given a blog with content exists
    When I run `staticpress list route`
    Then the output should contain "/"
    And the output should contain "/about"
    And the output should contain "/hello-goodbye"

  Scenario: Building a site
    Given a blog with content exists
    Then a directory named "public" should not exist
    When I run `staticpress build`
    Then a directory named "public" should exist
    And the following files should exist:
      | public/index.html       |
      | public/about/index.html |

  Scenario: Pushing a compiled site to a remote location
    Given a blog with content exists
    And the blog has been previously built
    And I append to "config.yml" with:
      """
      :deployment_strategies:
        :custom: 'cp -R public ../deployed'
      """
    When I run `staticpress push`
    Then the following files should exist:
      | ../deployed/index.html       |
      | ../deployed/about/index.html |
