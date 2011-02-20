Feature: Create person
  
  So that I can add a person to a schedule
  As a site admin
  I want to create a person

  Scenario: Create a person with a guitarist role via the model code
    Given a role named Guitarist
    When I create a person Dan Bailey with a role of Guitarist
    Then Dan Sowerbutts should be listed in the Guitarist role

  Scenario: Create a person with a drummer role via a web browser
    Given a role named Drummer
    When I create a person Dave Grohl and select a role of Drummer
    Then Dave Grohl should be listed as a Drummer in the summary table
