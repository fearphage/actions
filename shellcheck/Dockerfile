FROM koalaman/shellcheck-alpine

RUN apk --no-cache add jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
