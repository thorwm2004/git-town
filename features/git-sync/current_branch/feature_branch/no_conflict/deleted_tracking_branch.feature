Feature: git sync: restores deleted tracking branch

  As a developer syncing a feature branch whose tracking branch has been deleted
  I want to be asked whether to delete that branch from my local machine
  So that I can keep my local client in sync with what is happening on the remote repository.


  Background:
    Given I have a feature branch named "feature"
    And the following commits exist in my repository
      | BRANCH  | LOCATION         | MESSAGE        | FILE NAME    |
      | feature | local and remote | feature commit | feature_file |
    And the "feature" branch gets deleted on the remote
    And I am on the "feature" branch
    When I run `git sync` and enter "yes"


  @debug-commands
  Scenario: result
    Then I see "The branch 'feature' was deleted on the remote"
    And it runs the commands
      | BRANCH  | COMMAND                    |
      | feature | git fetch --prune          |
      |         | git checkout main          |
      | main    | git rebase origin/main     |
      |         | git branch -D feature      |
    And I end up on the "main" branch
    And there are no commits
