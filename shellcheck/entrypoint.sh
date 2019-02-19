#!/usr/bin/env sh

if [ -z "$GITHUB_TOKEN" ]; then
	>&2 echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [ -z "$GITHUB_SHA" ]; then
	>&2 echo "Set the GITHUB_SHA env variable."
	exit 1
fi

parse_json() {
  jq --slurp --arg name "$GITHUB_ACTION" --arg now "$(timestamp)" 'flatten | {
    completed_at: $now,
    conclusion: (if map(select(.level == "error")) | length > 0 then "failure" else "success" end),
    output: {
      title: $name,
      summary: map({level: .level}) | group_by(.level) | map({key: .[0].level, value: length}) | from_entries | "\(.error // 0) error(s) / \(.warning // 0) warning(s) / \(.info // 0) messages",
      annotations: map({
        path: .file,
        start_line: .line,
        end_line: .endLine,
        start_column: .column,
        end_column: .endColumn,
        annotation_level: (if .level == "info" then "notice" elif .level == "error" then "failure" else .level end),
        message: .message
      })
    }
  }'
}

request() {
  if [ -n "$3" ]; then
    method='PATCH'
    suffix="/$3"
  else
    method='POST'
    suffix=''
  fi

  >&2 echo "DEBUG: URL $1 ; method $method"

  curl -sSL \
    --request "$method" \
    --header 'Accept: application/vnd.github.antiope-preview+json' \
    --header "Authorization: token ${GITHUB_TOKEN}" \
    --header 'Content-Type: application/json' \
    --data "$2" \
    "${1}/check-runs${suffix}"
}

run_shellcheck() {
  (find . -type f -name "*.sh" -exec "shellcheck" "--format=json" {} \;

  # shellcheck disable=SC2013
  for file in $(grep -IRl "#\!\(/usr/bin/env \|/bin/\)sh" --exclude-dir ".git" --exclude-dir "node_modules" --exclude "*.txt" --exclude "*.sh"); do
    shellcheck --format=json --shell=sh "$file"
  done) | jq --slurp 'flatten'
}

timestamp() {
  date +%Y-%m-%dT%H:%M:%SZ
}

main() {
  action=$(jq --raw-output .action "$GITHUB_EVENT_PATH")
  url=$(jq --raw-output .repository.url "$GITHUB_EVENT_PATH")

  >&2 echo "DEBUG: PR $action / url $url"

  json='{"name":"'"${GITHUB_ACTION}"'","status":"in_progress","started_at":"'"$(timestamp)"'","head_sha": "'"${GITHUB_SHA}"'"}'

  # start check
  response=$(request "$url" "$json")
  id=$(echo "$response" | jq --raw-output .id)

  >&2 echo "DEBUG: response $response / json: $json / id: $id"

  if [ -z "$id" ] || [ "$id" = "null" ]; then
    exit 78
  fi

  results=$(run_shellcheck)
  if [ "$(jq --raw-output length "$results")" -eq 0 ]; then
    exit 0
  fi

  json=$(run_shellcheck | parse_json)
  >&2 echo "DEBUG: pre-patch json => $json"
  response=$(request "$url" "$json" "$id")
  >&2 echo "DEBUG: response $response"
}

main "$@"