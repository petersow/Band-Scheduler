Feature: Create role
  
  So that I can assign roles to a person and a performance
  As a site admin
  I want to create a role

  Scenario: Create a role with the name Singer via the model code
    Given an empty role table
    When I create a role Singer
    Then there should be exactly 1 role with the name Singer

  Scenario: Create a role with the name Dancer via a web browser
    Given a role named Drummer
    When via the web I create a role Dancer
    Then there should be exactly 2 roles, 1 with the name Dancer and 1 with the name Drummer
