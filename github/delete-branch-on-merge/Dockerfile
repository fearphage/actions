FROM alpine:latest

LABEL "com.github.actions.name"="Delete branches after they're merged"
LABEL "com.github.actions.description"="Cleans up old branches"
LABEL "com.github.actions.icon"="delete"
LABEL "com.github.actions.color"="red"

RUN	apk add --no-cache \
	bash \
	ca-certificates \
	curl \
	jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
