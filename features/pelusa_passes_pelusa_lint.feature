Feature: Pelusa passes pelusa lint
  In order to be credible
  As a linting tool
  Pelusa must pass its lints itself

  Scenario: Pelusa passes its lints
    Given I run pelusa in its own codebase
    When I look at the results
    Then I should see no failed lints

