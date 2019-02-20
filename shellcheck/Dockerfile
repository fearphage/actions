FROM koalaman/shellcheck-alpine

RUN apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
