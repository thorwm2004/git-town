Feature: git town-rename-branch: errors if renaming a perennial branch that has unpulled changes

  As a developer renaming a perennial branch that has unpulled changes
  I should get an error that the given branch is not in sync with its tracking branch
  So that I don't lose work by deleting branches that contain commits that haven't been pulled yet.


  Background:
    Given I have a perennial branch named "production"
    And the following commits exist in my repository
      | BRANCH     | LOCATION         | MESSAGE                  |
      | main       | local and remote | main commit              |
      | production | local and remote | production commit        |
      |            | remote           | remote production commit |
    And I am on the "production" branch
    And I have an uncommitted file
    When I run `git town-rename-branch production renamed-production -f`


  Scenario: result
    Then I get the error "The branch is not in sync with its tracking branch."
    And I get the error "Run 'git town-sync production' to sync the branch."
    And I end up on the "production" branch
    And I still have my uncommitted file
    And I am left with my original commits
