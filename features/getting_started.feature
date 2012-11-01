Feature: Getting started

  Scenario: Getting help
    Given I ask for help
    Then I am pointed in the right direction

  Scenario: Finding the version
    Given I want Staticpress' version
    Then I see the version

  Scenario: Creating a new blog
    When I make a new blog
    Then the minimal files are present

  Scenario: Creating a new blog with a custum title
    When I make a new blog called "This is my blog"
    Then Staticpress should remember my blog title
