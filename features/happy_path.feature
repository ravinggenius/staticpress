Feature: The happy path

  Scenario: Creating a new blog
    When I run `staticpress new my_new_blog`
    Then the exit status should be 0
    And the following files should exist:
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
    Then the exit status should be 0
    And a directory named "content/_posts" should exist
    And a post named "hello-world" should exist
