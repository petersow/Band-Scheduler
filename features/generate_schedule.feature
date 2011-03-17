Feature: Create schedule

  So that I can view the events
  As a site admin
  I want to generate a schedule

  Scenario: Generate a schedule which creates events for the performances
    Given a role named Guitarist
    And a Person named Dan Sowerbutts with a Role of Guitarist
    And a Performance with 1 Guitarist
    When I fire off the scheduler generator
    Then there should be an Event with Dan Sowerbutts filling the Guitarist role for the Performance
