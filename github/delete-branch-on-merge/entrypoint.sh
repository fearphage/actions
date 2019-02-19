#!/usr/bin/env bash

set -eo pipefail

if [ -z "$GITHUB_TOKEN" ]; then
  2>& echo 'GITHUB_TOKEN secret is required'
  exit 1
fi

function json {
  jq --raw-output "$1" "$GITHUB_EVENT_PATH"
}

function main {
  local action
  local default_branch
  local merged
  local ref

  action=$(json .action)
  default_branch=$(json .pull_request.base.repo.default_branch)
  merged=$(json .pull_request.merged)
  ref=$(json .pull_request.head.ref)

  >&2 echo "DEBUG: \$action = $action"
  >&2 echo "DEBUG: \$default_branch = $default_branch"
  >&2 echo "DEBUG: \$merged = $merged"
  >&2 echo "DEBUG: \$ref = $ref"

  if [ "$action" = "closed" ] && [ "$merged" = "true" ]; then
    if [ "$(json .pull_request.base.repo.full_name)" != "$(json .pull_request.head.repo.full_name)" ]; then
      >&2 echo "No access to remove branches from $(json .pull_request.head.repo.full_name), exiting."
      exit 0
    fi

    if [ "$ref" != "$default_branch" ]; then
      >&2 echo "Deleting branch $ref from $(json .pull_request.head.repo.full_name)"

      # curl \
        # --request DELETE \
        # --header "Accept: application/vnd.github.v3+json" \
        # --header "Authorization: token $GITHUB_TOKEN" \
        # "$(json .pull_request.head.repo.url)/git/refs/heads/$ref"

      # >&2 echo "Branch deleted successfully!"
    fi
  fi
}

main "$@"
