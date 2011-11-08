Feature: The happy path

  Scenario: Creating a new blog
    When I run `staticpress new my_new_blog`
    Then the exit status should be 0
    And the following files should exist:
      | my_new_blog/config.ru       |
      | my_new_blog/config.yml      |
      | my_new_blog/Gemfile         |
      | my_new_blog/README.markdown |
