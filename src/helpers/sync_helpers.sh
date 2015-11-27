#!/usr/bin/env bash

# Helper functions for syncing branches


# Outputs the steps to sync the given branch
function sync_branch_steps {
  local branch=$1
  local is_feature ; is_feature="$(is_feature_branch "$branch")"

  echo "checkout $branch"

  if [ "$is_feature" = true ]; then
    echo "merge_tracking_branch"
    echo "merge $(parent_branch "$branch")"
  else
    echo "rebase_tracking_branch"

    if [ "$branch" = "$MAIN_BRANCH_NAME" ] && [ "$(has_remote_upstream)" = true ]; then
      echo "fetch_upstream"
      echo "rebase upstream/$MAIN_BRANCH_NAME"
    fi
  fi
}
