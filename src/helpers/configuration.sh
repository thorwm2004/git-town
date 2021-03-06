#!/usr/bin/env bash

# Performs initial configuration before running any Git Town command,
# unless the `--bypass-automatic-configuration` option is passed (used by git-town)


# Migrate old configuration (Git Town v0.2.2 and lower)
if [[ -f ".main_branch_name" ]]; then
  store_configuration main-branch-name "$(cat .main_branch_name)"
  rm .main_branch_name
fi

# Migrate old configuration (Git Town v0.6 and lower)
non_feature_branch_names=$(git config --get-all git-town.non-feature-branch-names)
if [ -n "$non_feature_branch_names" ]; then
  git config --add git-town.perennial-branch-names "$non_feature_branch_names"
  git config --unset git-town.non-feature-branch-names
fi

export MAIN_BRANCH_NAME=$(get_configuration main-branch-name)
export PERENNIAL_BRANCH_NAMES=$(get_configuration perennial-branch-names)
export PULL_BRANCH_STRATEGY=$(get_configuration pull-branch-strategy)
if [ -z "$PULL_BRANCH_STRATEGY" ]; then
  PULL_BRANCH_STRATEGY="rebase"
fi
export HACK_PUSH_FLAG=$(get_configuration hack-push-flag)
if [ -z "$HACK_PUSH_FLAG" ]; then
  HACK_PUSH_FLAG="true"
fi


# Bypass the configuration if requested by caller (e.g. git-town)
if [[ "$@" =~ --bypass-automatic-configuration ]]; then
  return 0
fi

if [ "$(are_perennial_branches_configured)" = false ] && [ "$(is_main_branch_configured)" = false ]; then
  ensure_knows_configuration
fi
