Feature: Create performance

  So that I can fill the schedule with performances
  As a site admin
  I want to create a performance

  Scenario: Create a performance with 1 Guitarist and 1 Drummer via the model code
    Given a role named Guitarist
    And a role named Drummer
    When I create a performance with 1 Guitarist and 1 Drummer
    Then there should be a performance listed with 1 Guitarist and 1 Drummer
