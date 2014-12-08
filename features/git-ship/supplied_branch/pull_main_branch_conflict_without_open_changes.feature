Feature: Git Ship: handling conflicting remote main branch updates when shipping the supplied feature branch without open changes


  Background:
    Given I have feature branches named "feature" and "other_feature"
    And the following commits exist in my repository
      | BRANCH  | LOCATION | MESSAGE                   | FILE NAME        | FILE CONTENT               |
      | main    | remote   | conflicting remote commit | conflicting_file | remote conflicting content |
      |         | local    | conflicting local commit  | conflicting_file | local conflicting content  |
      | feature | local    | feature commit            | feature_file     | feature content            |
    And I am on the "other_feature" branch
    And I run `git ship feature -m 'feature done'` while allowing errors


  Scenario: result
    Then my repo has a rebase in progress
    And there is an abort script for "git ship"


  Scenario: aborting
    When I run `git ship --abort`
    Then I am still on the "other_feature" branch
    And there is no rebase in progress
    And there is no abort script for "git ship" anymore
    And I still have the following commits
      | BRANCH  | LOCATION | MESSAGE                   | FILES            |
      | main    | remote   | conflicting remote commit | conflicting_file |
      |         | local    | conflicting local commit  | conflicting_file |
      | feature | local    | feature commit            | feature_file     |
    And I still have the following committed files
      | BRANCH  | FILES            | CONTENT                   |
      | main    | conflicting_file | local conflicting content |
      | feature | feature_file     | feature content           |
