Feature: The happy path

  Scenario: Some basic commands
    Given I run `staticpress`
    Then the exit status should be 0
    And the output should contain "Usage"

    Given I run `staticpress help`
    Then the exit status should be 0
    And the output should contain "Usage"

    Given I run `staticpress -h`
    Then the exit status should be 0
    And the output should contain "Usage"

    Given I run `staticpress --help`
    Then the exit status should be 0
    And the output should contain "Usage"

    Given I run `staticpress version`
    Then the exit status should be 0
    And the output should contain "Staticpress"

    Given I run `staticpress -v`
    Then the exit status should be 0
    And the output should contain "Staticpress"

    Given I run `staticpress --version`
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

  Scenario: Creating a static page with multiple formats
    Given a blog exists
    When I write to "content/formats.markdown.erb" with:
      """
      hello world
      """
    And I run `staticpress build`
    Then the file "public/formats/index.html" should contain exactly:
      """
      <!DOCTYPE html>
      <html>
        <head>
          <title>Formats | Transient Thoughts</title>
          <link href='/assets/basic/styles/all.css' rel='stylesheet' type='text/css' />
          <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js'></script>
          <script src='/assets/basic/scripts/application.js'></script>
        </head>
        <body>
          <header>
            <span class='site-title'>Transient Thoughts</span>
            <span class='site-subtitle'>A blogging framework for hackers</span>
          </header>
          <section>
            <p>hello world</p>
          </section>
          <section></section>
        </body>
      </html>

      """

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
    When I run `staticpress list url_path`
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

  Scenario: Building a site (verbose)
    Given a blog with content exists
    When I run `staticpress build --verbose`
    Then the output should contain "    page public/about/index.html"

  Scenario: Building a site with a custom homepage
    Given a blog with content exists
    And I write to "content/index.markdown" with:
      """
      ---
      title: Custom Home Page
      ---
      in custom page
      """
    # FIXME hacky-hack to keep Tilt happy
    # NOTE this does not seem to be an issue when running this command for real
    And I require "haml"
    And I require "redcarpet"
    And I require "sass"
    When I run `staticpress build`
    Then the file "public/index.html" should contain exactly:
      """
      <!DOCTYPE html>
      <html>
        <head>
          <title>Custom Home Page | Transient Thoughts</title>
          <link href='/assets/basic/styles/all.css' rel='stylesheet' type='text/css' />
          <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js'></script>
          <script src='/assets/basic/scripts/application.js'></script>
        </head>
        <body>
          <header>
            <span class='site-title'>Transient Thoughts</span>
            <span class='site-subtitle'>A blogging framework for hackers</span>
          </header>
          <section>
            <p>in custom page</p>
          </section>
          <section></section>
        </body>
      </html>

      """

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

  Scenario: Deploying site (build and push in one step)
    Given a blog with content exists
    And I append to "config.yml" with:
      """
      :deployment_strategies:
        :custom: 'cp -R public ../deployed'
      """
    Then the following files should not exist:
      | public/index.html            |
      | public/about/index.html      |
      | ../deployed/index.html       |
      | ../deployed/about/index.html |
    When I run `staticpress deploy`
    Then the following files should exist:
      | public/index.html            |
      | public/about/index.html      |
      | ../deployed/index.html       |
      | ../deployed/about/index.html |
