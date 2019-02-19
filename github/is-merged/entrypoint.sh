#!/usr/bin/env bash

set -eo pipefail

if [ -z "$GITHUB_EVENT_PATH" ]; then
  >&2 echo "\$GITHUB_EVENT_PATH not found"
  exit 1
fi

function main {
  local merged

  merged=$(jq .pull_request.merged "$GITHUB_EVENT_PATH")

  if [ "$merged" != "true" ]; then
    >&2 "PR status not met: expected: $1 / actual: $merged"
    exit 78
  fi
}

main "$@"
