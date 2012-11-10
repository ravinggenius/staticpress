Feature: Editing blog contents

  Background:
    Given a blog with content exists

  Scenario: Creating a static page with multiple formats
    When I create a simple page with multiple formats
    And build the site
    Then the formats page only contains markup

  Scenario: Listing all routes
    When I list my blog's URLs
    Then the static pages are present

  Scenario: Building a site
    Then the output directory does not exist
    When I build the site
    Then the output directory contains some markup files

  Scenario: Building a site (verbose)
    When I build the site verbosely
    Then I see each output file

  Scenario: Building a site with a custom homepage
    When I create a custom home page
    And I build the site
    Then the build homepage looks good

  Scenario: Pushing a compiled site to a remote location
    Given I build the site
    When I add a custom deployment strategy
    And push the site
    Then the site is deployed

  Scenario: Deploying site (build and push in one step)
    Given I add a custom deployment strategy
    And the site is not built or deployed
    When I deploy the site
    Then the output directory contains some markup files
    And the site is deployed
