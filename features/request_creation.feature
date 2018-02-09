Feature: Request and test case creation
  Test request and test case creation with global vars

  Scenario: Create environment, add collections and requests
    Given I login as regular user
    When I "select" an existing project
    And I create environment "PREPROD"
    And I create global variables for created environment:
      | key         |
      | $user       |
      | $pwd        |
      | $project_id |
    And I create these request collections:
      | collection  |
      | Login       |
      | Projects    |
    Then I create request "Positive login" for collection "Login"
    And I create request "Set activate project" for collection "Projects"
    
  Scenario: Create a test case
    Given I login as regular user
    And I "select" an existing project
    And I create environment "PREPROD"
    When I create global variables for created environment:
      | key         |
      | $user       |
      | $pwd        |
      | $project_id |
    And I create these request collections:
      | collection  |
      | Login       |
      | Projects    |
    And I create request "Positive login" for collection "Login"
    And I create request "Set activate project" for collection "Projects"
    Then I add these requests to test case "Set active project":
      | request_name         |
      | Positive login       |
      | Set activate project |
    And I check if test case "Set active project" is created