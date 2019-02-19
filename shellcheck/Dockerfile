FROM koalaman/shellcheck-alpine

RUN apk add --no-cache \
  bash \
  jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
