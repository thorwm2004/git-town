#!/usr/bin/env bash


# Pushes all of the given branches to the remote
function push_branches {
  local branch_names="$@"
  local set_upstream=false
  local filtered_branch_names=()

  for branch_name in ${branch_names[@]}; do
    if [ "$(has_tracking_branch "$branch_name")" = false ]; then
      set_upstream=true
      filtered_branch_names+=($branch_name)
    elif [ "$(branch_needs_push "$branch_name")" = true ]; then
      filtered_branch_names+=($branch_name)
    fi
  done

  local cmd='git push'
  if [ "$set_upstream" = true ]; then
    cmd="$cmd -u origin"
  fi
  run_command "$cmd ${filtered_branch_names[*]}"
}


function undo_steps_for_push_branches {
  local branch_names="$@"
  local branch_names_to_delete=()

  for branch_name in ${branch_names[@]}; do
    if [ "$(has_tracking_branch "$branch_name")" = false ]; then
      filtered_branch_names+=($branch_name)
    elif [ "$(branch_needs_push "$branch_name")" = true ]; then
      if [ $branch_name = $(get_current_branch_name) ]; then
        echo "skip_current_branch_steps $UNDO_STEPS_FILE"
      else
        echo "skip_branch_steps $branch_name $UNDO_STEPS_FILE"
      fi
    fi
  done

  if [ "${#filtered_branch_names[@]}" != 0 ]; then
    echo "delete_remote_branches ${filtered_branch_names[*]}"
  fi
}


# Pushes tags to the remote
function push_tags {
  run_command "git push --tags"
}
