#!/usr/bin/env bash

set -eo pipefail

if [ -z "$GITHUB_EVENT_PATH" ]; then
  >&2 echo "\$GITHUB_EVENT_PATH not found"
  exit 1
fi

function main {
  local action
  local merged

  action=$(jq .action "$GITHUB_EVENT_PATH")
  merged=$(jq .pull_request.merged "$GITHUB_EVENT_PATH")

  # https://developer.github.com/v3/activity/events/types/#events-api-payload-28
  if [ "$action" != "closed" ] || [ "$merged" != "true" ]; then
    >&2 "PR status not met - \$action: $action / \$merged: $merged"
    exit 78
  fi
}

main "$@"
