#!/usr/bin/env bash

# Helper functions for syncing branches


# Outputs the steps to sync the given branch
function sync_branch_steps {
  local branch=$1
  local is_feature="$(is_feature_branch "$branch")"

  # If there is a remote origin, then checkout and sync all branches because
  # there may be changes to perennial branches, otherwise only sync feature
  # branches because perennial branches will not need syncing
  if [ "$HAS_REMOTE" = true ] || [ "$is_feature" = true ]; then
    step "checkout $branch"

    if [ "$is_feature" = true ]; then
      step "merge_tracking_branch"
      step "merge $(parent_branch "$branch")"
    else
      step "rebase_tracking_branch"
    fi

    if [ "$HAS_REMOTE" = true ]; then
      if [ "$(has_tracking_branch "$branch")" == true ]; then
        step "push_branch $branch"
      else
        # tracking branch got deleted on the remote
        echo "The branch '$branch' was deleted on the remote."
        echo "This most likely means it was shipped or deleted by another developer."
        echo "Do you want to remove it from your local copy?"
        echo "If you answer 'n', this branch will be kept and pushed back to the repository."
        echo -n "(y/n)"
        read user_input
        read user_input_2
        echo "XXXXXXXXXXXXX"
        echo "$user_input"
        echo "YYYYYYYYYYYYY"
        echo "$user_input_2"
        if [ "$user_input" == "y" ]; then
          # User wants to delete the current branch from the local machine
          step "delete_local_branch $branch force"
          local parent_branch_name=$(parent_branch "$branch")
          steps_to_update_child_branches "$branch" "$parent_branch_name"
          step "delete_parent_entry $branch"
          step "delete_all_ancestor_entries"
        else
          # User wants to keep the current branch --> push it to the remote
          step "create_tracking_branch $branch"
        fi
      fi
    fi
  fi
}
